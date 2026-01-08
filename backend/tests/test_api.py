"""
Unit tests for FastAPI backend endpoints
"""
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


class TestHealthEndpoint:
    """Tests for /api/health endpoint"""

    def test_health_check_returns_200(self):
        """Test that health endpoint returns 200 status code"""
        response = client.get("/api/health")
        assert response.status_code == 200

    def test_health_check_returns_healthy_status(self):
        """Test that health endpoint returns healthy status in response body"""
        response = client.get("/api/health")
        data = response.json()
        assert data["status"] == "healthy"
        assert "message" in data
        assert data["message"] == "Backend is running successfully"


class TestMessageEndpoint:
    """Tests for /api/message endpoint"""

    def test_message_endpoint_returns_200(self):
        """Test that message endpoint returns 200 status code"""
        response = client.get("/api/message")
        assert response.status_code == 200

    def test_message_endpoint_returns_correct_message(self):
        """Test that message endpoint returns the expected message"""
        response = client.get("/api/message")
        data = response.json()
        assert "message" in data
        assert data["message"] == "You've successfully integrated the backend!"
