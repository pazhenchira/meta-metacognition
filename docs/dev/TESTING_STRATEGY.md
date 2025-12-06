# Integration & System Testing Guide

**NOTE**: This document supplements `.meta/AGENTS.md` with Phase 1 testing requirements.

---

## Test Pyramid Strategy

The meta-cognitive pipeline must produce applications with comprehensive test coverage following the test pyramid:

```
              ┌─────────────┐
              │  Manual/E2E │  ← Few, expensive
              │   (System)  │
              ├─────────────┤
              │Integration  │  ← Moderate number
              │   Tests     │
              ├─────────────┤
              │   Unit      │  ← Many, fast
              │   Tests     │
              └─────────────┘
```

### Test Levels

1. **Unit Tests** (per LEGO)
   - Test individual LEGO behavior in isolation
   - Mock all dependencies
   - Fast execution (<1s per test)
   - High coverage (>80% of LEGO code)

2. **Integration Tests** (cross-LEGO)
   - Test interactions between 2-3 LEGOs
   - Use real implementations (minimal mocking)
   - Moderate execution time (<10s per test)
   - Cover critical data flows

3. **System Tests** (E2E)
   - Test full user journeys
   - All LEGOs integrated
   - Real or realistic external services
   - Slower execution (minutes)
   - Cover happy paths + critical error scenarios

---

## When to Generate Each Test Type

### Unit Tests (Always)
- Generated during **LEGO-Orchestrator TEST AUTHORING substep**
- Location: `tests/test_<lego>.py` (or equivalent)
- Run during LEGO VALIDATION substep
- Must pass before LEGO marked as "done"

### Integration Tests (if `enable_integration_tests: true`)
- Generated **after all dependent LEGOs are "done"**
- Location: `tests/integration/test_<lego_a>_<lego_b>.py`
- Run by a dedicated Integration Test Agent (post-LEGO completion)

### System Tests (if `enable_system_tests: true`)
- Generated **after all LEGOs are "done"**
- Location: `tests/system/test_<user_journey>.py`
- Run by a dedicated System Test Agent (final pipeline stage)

---

## LEGO Plan Extensions for Testing

In `lego_plan.json`, LEGOs can now have `type`:

```json
{
  "legos": [
    {
      "name": "auth",
      "type": "implementation",
      "responsibility": "Handle user authentication",
      ...
    },
    {
      "name": "integration_auth_data",
      "type": "integration_test",
      "responsibility": "Test auth + data_layer integration",
      "tests": ["user login with database", "session persistence"],
      "dependencies": ["auth", "data_layer"]
    },
    {
      "name": "system_user_onboarding",
      "type": "system_test",
      "responsibility": "E2E test of user onboarding flow",
      "tests": ["new user signup → login → profile setup"],
      "dependencies": ["auth", "data_layer", "api_gateway"]
    }
  ]
}
```

### LEGO Types

- `implementation`: Normal LEGO with src code
- `config_validation`: Validates setup and guides configuration (always generated)
- `integration_test`: Tests 2+ implementation LEGOs
- `system_test`: Tests full user journey (E2E)
- `performance_test`: Load/stress testing (future)

---

## Configuration Validation Testing

**CRITICAL**: Every application MUST have E2E tests for configuration validation and setup workflows.

### Config Validation LEGO (Always Generated)

The meta-orchestrator ALWAYS generates a `config_validator` LEGO that:
- Checks all required environment variables
- Validates external service connectivity
- Tests API keys with lightweight calls
- Provides guided setup wizard
- Generates CONFIGURATION.md

### Required E2E Tests for Configuration

```python
# tests/system/test_config_validation.py

def test_missing_env_var_detected():
    """System Test: App detects missing required env var and fails gracefully"""
    env = os.environ.copy()
    del env['DATABASE_URL']
    
    result = subprocess.run(['python', 'main.py'], env=env, capture_output=True, text=True)
    
    assert result.returncode != 0
    assert "Missing required environment variables" in result.stderr
    assert "DATABASE_URL" in result.stderr

def test_invalid_service_connection_detected():
    """System Test: App detects unreachable external service"""
    env = os.environ.copy()
    env['DATABASE_URL'] = 'postgresql://invalid:5432/db'
    
    result = subprocess.run(['python', 'main.py'], env=env, capture_output=True, text=True)
    
    assert result.returncode != 0
    assert "Cannot connect to database" in result.stderr
    assert "docker-compose up" in result.stderr  # Guidance provided

def test_setup_wizard_generates_working_config():
    """System Test: Setup wizard creates valid configuration"""
    if os.path.exists('.env'):
        os.remove('.env')
    
    input_data = "postgresql://localhost:5432/testdb\ntest-api-key\n"
    result = subprocess.run(
        ['python', 'main.py', '--setup-wizard'],
        input=input_data,
        capture_output=True,
        text=True
    )
    
    assert os.path.exists('.env')
    assert "Setup complete" in result.stdout
    
    # Verify app can now start
    result = subprocess.run(['python', 'main.py'], capture_output=True)
    assert result.returncode == 0

def test_health_check_reflects_config_status():
    """System Test: Health endpoint validates all configuration"""
    app = start_app()
    response = requests.get('http://localhost:8000/health')
    
    assert response.status_code == 200
    assert response.json()['status'] == 'healthy'
    assert 'DATABASE_URL' in response.json()['details']
    assert 'API_KEY' in response.json()['details']
    
    app.terminate()
```

See **`CONFIG_VALIDATION.md`** for complete implementation guide.

---

## Integration Test Structure

```python
# tests/integration/test_auth_data.py

import pytest
from src.auth import AuthService
from src.data_layer import DatabaseService

@pytest.fixture
def services():
    """Set up real instances of both LEGOs"""
    db = DatabaseService(connection_string="test_db")
    auth = AuthService(db)
    return auth, db

def test_user_login_with_database(services):
    """Integration: Auth LEGO authenticates user stored in Database LEGO"""
    auth, db = services
    
    # Arrange: Create user in database
    db.create_user(username="test@example.com", password_hash="...")
    
    # Act: Authenticate via Auth LEGO
    result = auth.login("test@example.com", "password123")
    
    # Assert: Login succeeds and session persists in database
    assert result.success == True
    assert db.get_session(result.session_id) is not None
```

**Key characteristics**:
- Uses real implementations (no mocks for the LEGOs being tested)
- May mock external services (APIs, third-party)
- Tests the **contract/interface** between LEGOs
- Validates data flow across LEGO boundaries

---

## System Test Structure

```python
# tests/system/test_user_onboarding.py

import pytest
import requests
from selenium import webdriver  # or API client

@pytest.fixture
def app_client():
    """Set up test environment with all LEGOs running"""
    # Could be: deployed staging env, local docker-compose, in-memory test instance
    return TestAppClient(base_url="http://localhost:8000")

def test_complete_user_onboarding_journey(app_client):
    """System Test: New user signs up, logs in, and sets up profile"""
    
    # Step 1: User visits signup page
    response = app_client.get("/signup")
    assert response.status_code == 200
    
    # Step 2: User submits signup form
    signup_data = {
        "email": "newuser@example.com",
        "password": "SecurePass123!",
        "name": "Test User"
    }
    response = app_client.post("/signup", json=signup_data)
    assert response.status_code == 201
    user_id = response.json()["user_id"]
    
    # Step 3: User logs in
    login_data = {"email": "newuser@example.com", "password": "SecurePass123!"}
    response = app_client.post("/login", json=login_data)
    assert response.status_code == 200
    token = response.json()["token"]
    
    # Step 4: User accesses profile (authenticated)
    headers = {"Authorization": f"Bearer {token}"}
    response = app_client.get(f"/users/{user_id}/profile", headers=headers)
    assert response.status_code == 200
    assert response.json()["email"] == "newuser@example.com"
```

**Key characteristics**:
- Tests through public interfaces (HTTP, CLI, UI)
- All LEGOs integrated
- Mimics real user behavior
- May require test data setup/teardown
- Validates **business requirements** from `requirements.md`

---

## Test Agents (Dedicated Sessions)

### Integration Test Agent
- Spawned after all implementation LEGOs for a subsystem are "done"
- Reads `lego_plan.json` to find LEGOs with `type: "integration_test"`
- Generates and runs integration tests
- Updates `lego_state_integration_<name>.json`

### System Test Agent
- Spawned as final pipeline stage (after all implementation + integration LEGOs)
- Reads `requirements.md` Section 7 (Evaluation & Success Criteria)
- Generates E2E tests for critical user journeys
- May deploy to staging environment
- Updates `system_test_results.json`

---

## Contract Testing

For LEGOs with explicit interfaces, generate **contract tests**:

```python
# tests/contracts/test_auth_contract.py

def test_auth_service_interface():
    """Verify Auth LEGO implements expected interface"""
    from src.auth import AuthService
    
    auth = AuthService()
    
    # Check methods exist
    assert hasattr(auth, 'login')
    assert hasattr(auth, 'logout')
    assert hasattr(auth, 'validate_token')
    
    # Check method signatures
    import inspect
    sig = inspect.signature(auth.login)
    assert 'username' in sig.parameters
    assert 'password' in sig.parameters
```

**Purpose**: Prevent interface breaking changes during LEGO evolution.

---

## Test Execution Order

1. **During LEGO build** (LEGO-Orchestrator VALIDATION substep):
   - Run unit tests for that LEGO
   - Run linters
   
2. **After subsystem complete** (Integration Test Agent):
   - Run integration tests for that subsystem
   
3. **After all LEGOs done** (System Test Agent):
   - Run system/E2E tests
   - Optionally: performance tests, security scans

4. **Final Review** (Meta-Orchestrator):
   - Aggregate all test results
   - Document in `review.md`

---

## Configuration Flags

From `meta_config.json`:

```json
{
  "enable_integration_tests": true,   // Spawn Integration Test Agent?
  "enable_system_tests": true,        // Spawn System Test Agent?
  "test_coverage_threshold": 80,      // Min % for unit tests
  "integration_test_timeout_minutes": 10,
  "system_test_timeout_minutes": 30
}
```

---

## Benefits

✅ **Confidence**: Know that LEGOs work together, not just in isolation
✅ **Regression prevention**: Catch integration bugs early
✅ **Requirements validation**: System tests verify business goals
✅ **Documentation**: Tests serve as executable specifications
✅ **Continuous improvement**: Failed tests reveal design issues

---

## Integration with .meta/AGENTS.md

This document **extends** .meta/AGENTS.md:

- Section 5 (LEGO Discovery): Now includes test-type LEGOs
- Section 8 (LEGO-Orchestrator Sessions): After implementation LEGOs, spawn test LEGOs
- Section 11 (Final Review): Include integration & system test results
