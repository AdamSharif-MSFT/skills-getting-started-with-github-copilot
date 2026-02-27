"""Tests for the Mergington High School API."""

import copy
import pytest
from fastapi.testclient import TestClient
from src.app import app, activities


@pytest.fixture(autouse=True)
def reset_activities():
    """Reset the in-memory activities database before each test."""
    original = copy.deepcopy(activities)
    yield
    activities.clear()
    activities.update(original)


client = TestClient(app)


def test_root_redirects_to_index():
    # Arrange
    url = "/"

    # Act
    response = client.get(url, follow_redirects=False)

    # Assert
    assert response.status_code == 307
    assert response.headers["location"] == "/static/index.html"


def test_get_activities_returns_all():
    # Arrange
    expected_keys = {"description", "schedule", "max_participants", "participants"}

    # Act
    response = client.get("/activities")

    # Assert
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, dict)
    assert len(data) == 9
    for name, details in data.items():
        assert expected_keys.issubset(details.keys()), f"{name} missing keys"


def test_signup_success():
    # Arrange
    activity_name = "Chess Club"
    new_email = "newstudent@mergington.edu"

    # Act
    response = client.post(
        f"/activities/{activity_name}/signup?email={new_email}"
    )

    # Assert
    assert response.status_code == 200
    assert new_email in response.json()["message"]
    # Verify participant was actually added
    activities_response = client.get("/activities")
    assert new_email in activities_response.json()[activity_name]["participants"]


def test_signup_duplicate_returns_400():
    # Arrange
    activity_name = "Chess Club"
    existing_email = "michael@mergington.edu"  # already in Chess Club

    # Act
    response = client.post(
        f"/activities/{activity_name}/signup?email={existing_email}"
    )

    # Assert
    assert response.status_code == 400
    assert "already signed up" in response.json()["detail"].lower()


def test_signup_nonexistent_activity_returns_404():
    # Arrange
    fake_activity = "Underwater Basket Weaving"
    email = "test@mergington.edu"

    # Act
    response = client.post(
        f"/activities/{fake_activity}/signup?email={email}"
    )

    # Assert
    assert response.status_code == 404
    assert "Activity not found" in response.json()["detail"]


def test_signup_missing_email_returns_422():
    # Arrange
    activity_name = "Chess Club"

    # Act
    response = client.post(f"/activities/{activity_name}/signup")

    # Assert
    assert response.status_code == 422
