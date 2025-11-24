# Configuration Validation & Setup Workflows

**Purpose**: Ensure all applications have robust, multi-layered configuration validation and guided setup workflows that are E2E tested.

---

## Problem Statement

Most applications fail with cryptic errors when:
- Required environment variables are missing
- External services are unreachable
- Configuration files have invalid syntax
- Prerequisites (databases, message queues) aren't running
- API keys are invalid or expired
- Dependencies are missing or wrong versions
- Authentication workflows are not set up correctly

**Solution**: Every application MUST include:
1. **Multi-layered validation** (4 levels: dependencies → values → connectivity → workflows)
2. **Guided setup wizard** for first-time users/operators
3. **Comprehensive test coverage** (unit, integration, system/E2E tests for all validation layers)

---

## Four Validation Layers

Configuration validation must be comprehensive, not superficial. Each layer builds on the previous:

### Layer 1: Dependencies Installed ✅

**What**: Verify all dependencies are present and correct versions.

**Checks**:
- Runtime dependencies (Python version, Node version, system libraries)
- Development dependencies (pytest, linters, build tools)
- System tools (docker, psql, redis-cli, curl)
- Version compatibility (e.g., Python >= 3.9, Node >= 18)

**Example**:
```python
def validate_dependencies(self) -> Dict[str, bool]:
    """Check all dependencies are installed with correct versions"""
    checks = {}
    
    # Runtime: Python version
    import sys
    py_version = sys.version_info
    checks['python_3.9+'] = py_version >= (3, 9)
    
    # Runtime: Required packages
    try:
        import requests
        checks['requests'] = True
    except ImportError:
        checks['requests'] = False
    
    # System tools
    checks['docker'] = self._command_exists('docker')
    checks['psql'] = self._command_exists('psql')
    
    return checks

def _command_exists(self, cmd: str) -> bool:
    """Check if a system command exists"""
    import shutil
    return shutil.which(cmd) is not None
```

### Layer 2: Configuration Values Present & Well-Formed ✅

**What**: Verify config values exist and are syntactically valid.

**Checks**:
- Environment variables exist and non-empty
- Config files are parseable (valid JSON/YAML/TOML)
- URLs are well-formed (scheme, host, optional port)
- Ports are valid integers in range 1-65535
- Email addresses match expected format
- File paths exist and are readable/writable

**Example**:
```python
def validate_config_values(self) -> Dict[str, bool]:
    """Check config values are present and well-formed"""
    checks = {}
    
    # Env vars exist
    database_url = os.getenv('DATABASE_URL')
    checks['DATABASE_URL_exists'] = bool(database_url)
    
    # URL well-formed
    if database_url:
        from urllib.parse import urlparse
        parsed = urlparse(database_url)
        checks['DATABASE_URL_valid'] = bool(parsed.scheme and parsed.netloc)
    
    # Port valid
    port = os.getenv('PORT', '8000')
    try:
        port_int = int(port)
        checks['PORT_valid'] = 1 <= port_int <= 65535
    except ValueError:
        checks['PORT_valid'] = False
    
    # Config file parseable
    checks['config.json_valid'] = self._validate_json_file('config/app.json')
    
    return checks
```

### Layer 3: External Services Reachable & Authenticated ✅

**What**: Verify external services are accessible with valid credentials.

**Checks**:
- Database connections succeed (network + authentication)
- API keys are valid (make lightweight test API call)
- External service URLs are reachable (HTTP 200/401, not 404/500)
- Message queue connections work (Redis, RabbitMQ)
- Object storage accessible (S3, Azure Blob)
- OAuth flows configured correctly (if applicable)

**Example**:
```python
def validate_external_services(self) -> Dict[str, bool]:
    """Check external services are reachable with valid credentials"""
    checks = {}
    
    # Database connectivity
    db_url = os.getenv('DATABASE_URL')
    if db_url:
        checks['database_connection'] = self._test_db_connection(db_url)
    
    # API key validity
    api_key = os.getenv('OPENAI_API_KEY')
    if api_key:
        checks['openai_api_key'] = self._test_api_key(
            'OpenAI',
            api_key,
            'https://api.openai.com/v1/models'
        )
    
    # Redis connectivity
    redis_url = os.getenv('REDIS_URL')
    if redis_url:
        checks['redis_connection'] = self._test_redis_connection(redis_url)
    
    return checks

def _test_db_connection(self, connection_string: str) -> bool:
    """Test database connectivity"""
    try:
        import psycopg2
        conn = psycopg2.connect(connection_string, connect_timeout=5)
        cursor = conn.cursor()
        cursor.execute('SELECT 1')
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        self._log_error(f"Database connection failed: {e}")
        return False

def _test_api_key(self, service: str, key: str, endpoint: str) -> bool:
    """Test API key with lightweight call"""
    try:
        import requests
        response = requests.get(
            endpoint,
            headers={"Authorization": f"Bearer {key}"},
            timeout=5
        )
        return response.status_code in [200, 401]  # 401 = wrong key but endpoint exists
    except Exception as e:
        self._log_error(f"{service} API test failed: {e}")
        return False
```

### Layer 4: End-to-End Workflows Function ✅

**What**: Verify complete workflows work, including authentication, authorization, and data flows.

**Checks**:
- Test accounts exist for auth/authz testing (create if needed)
- Write → Read roundtrip works (database, cache, external API)
- User can authenticate and access protected resources
- Permissions are correct (RBAC/ABAC rules work)
- Integration between services works (auth + database + API)
- Webhooks/callbacks are configured (if applicable)

**Example**:
```python
def validate_e2e_workflows(self) -> Dict[str, bool]:
    """Check complete workflows function end-to-end"""
    checks = {}
    
    # Auth workflow (if app uses authentication)
    if self._uses_auth():
        checks['auth_workflow'] = self._test_auth_workflow()
    
    # Write → Read roundtrip
    checks['database_roundtrip'] = self._test_database_roundtrip()
    
    # External API integration
    if self._uses_external_api():
        checks['api_integration'] = self._test_api_integration()
    
    return checks

def _test_auth_workflow(self) -> bool:
    """Test complete authentication workflow"""
    try:
        # 1. Check test user exists
        test_user = os.getenv('TEST_USER_EMAIL')
        test_pass = os.getenv('TEST_USER_PASSWORD')
        
        if not test_user or not test_pass:
            print("⚠️ TEST_USER_EMAIL/PASSWORD not set")
            print("💡 Create test user: python scripts/create_test_user.py")
            return False
        
        # 2. Attempt login
        from src.auth import authenticate_user
        token = authenticate_user(test_user, test_pass)
        
        # 3. Access protected resource
        from src.api import get_user_profile
        profile = get_user_profile(token)
        
        return bool(token and profile)
    except Exception as e:
        self._log_error(f"Auth workflow failed: {e}")
        return False

def _test_database_roundtrip(self) -> bool:
    """Test write → read roundtrip"""
    try:
        from src.data_layer import DataLayer
        import uuid
        
        db = DataLayer()
        test_id = str(uuid.uuid4())
        test_data = {'test': True, 'id': test_id}
        
        # Write
        db.write('test_collection', test_id, test_data)
        
        # Read
        result = db.read('test_collection', test_id)
        
        # Cleanup
        db.delete('test_collection', test_id)
        
        return result == test_data
    except Exception as e:
        self._log_error(f"Database roundtrip failed: {e}")
        return False
```

---

## Configuration LEGO Type

In `lego_plan.json`, the meta-orchestrator MUST always generate a configuration validation LEGO:

```json
{
  "name": "config_validator",
  "type": "config_validation",
  "responsibility": "Validate all required configuration and guide setup",
  "priority": "critical",
  "execution_phase": "startup",
  "inputs": [".env", "config files", "external service endpoints"],
  "outputs": ["validation report", "setup wizard if needed"],
  "validations": [
    {
      "type": "env_var",
      "vars": ["DATABASE_URL", "API_KEY"],
      "required": true,
      "validation_fn": "check_env_var_exists_and_not_empty"
    },
    {
      "type": "external_service",
      "service": "PostgreSQL",
      "check": "connection_test",
      "guidance": "Run: docker-compose up -d postgres"
    },
    {
      "type": "api_key",
      "service": "OpenAI API",
      "check": "test_api_call",
      "guidance": "Get key from https://platform.openai.com/api-keys"
    }
  ],
  "dependencies": []
}
```

---

## Validation Patterns

### 1. Environment Variables

```python
# src/config_validator.py

import os
from typing import List, Dict

class ConfigValidator:
    def validate_env_vars(self, required: List[str]) -> Dict[str, bool]:
        """Check all required environment variables exist and are non-empty"""
        results = {}
        for var in required:
            value = os.getenv(var)
            results[var] = bool(value and value.strip())
        return results
    
    def generate_env_template(self, missing: List[str]):
        """Generate .env template for missing variables"""
        print("\n❌ Missing required environment variables:")
        print("\nAdd these to your .env file:\n")
        for var in missing:
            print(f"{var}=<your_value_here>")
        print("\nSee .env.example for details.")
```

### 2. External Service Connectivity

```python
def validate_database_connection(self, connection_string: str) -> bool:
    """Test database connectivity"""
    try:
        import psycopg2
        conn = psycopg2.connect(connection_string, connect_timeout=5)
        conn.close()
        return True
    except Exception as e:
        print(f"\n❌ Cannot connect to database:")
        print(f"   Error: {e}")
        print(f"\n💡 Suggested fixes:")
        print(f"   1. Start database: docker-compose up -d postgres")
        print(f"   2. Check connection string in .env")
        print(f"   3. Verify network connectivity")
        return False
```

### 3. API Key Validation

```python
def validate_api_key(self, service: str, key: str, test_endpoint: str) -> bool:
    """Test API key by making a lightweight API call"""
    import requests
    try:
        response = requests.get(
            test_endpoint,
            headers={"Authorization": f"Bearer {key}"},
            timeout=5
        )
        if response.status_code == 200:
            return True
        elif response.status_code == 401:
            print(f"\n❌ Invalid API key for {service}")
            print(f"💡 Get a valid key from: {self._get_service_url(service)}")
            return False
        else:
            print(f"\n⚠️ API returned unexpected status: {response.status_code}")
            return False
    except Exception as e:
        print(f"\n❌ Cannot reach {service} API: {e}")
        return False
```

### 4. Configuration File Syntax

```python
def validate_config_file(self, path: str, format: str) -> bool:
    """Validate config file syntax (JSON, YAML, TOML)"""
    try:
        if format == "json":
            with open(path) as f:
                json.load(f)
        elif format == "yaml":
            with open(path) as f:
                yaml.safe_load(f)
        elif format == "toml":
            with open(path) as f:
                toml.load(f)
        return True
    except Exception as e:
        print(f"\n❌ Invalid {format.upper()} in {path}:")
        print(f"   {e}")
        return False
```

---

## Guided Setup Wizard

When validation fails, launch an interactive setup wizard:

```python
def run_setup_wizard(self):
    """Interactive wizard for first-time setup"""
    print("\n🚀 Welcome! Let's set up your application.\n")
    
    # Step 1: Environment variables
    if not self._env_vars_valid():
        self._wizard_env_vars()
    
    # Step 2: External services
    if not self._services_reachable():
        self._wizard_services()
    
    # Step 3: API keys
    if not self._api_keys_valid():
        self._wizard_api_keys()
    
    # Step 4: Test connectivity
    print("\n✅ Running final validation...")
    if self.validate_all():
        print("✅ Setup complete! You're ready to go.")
    else:
        print("❌ Some issues remain. Please review the errors above.")

def _wizard_env_vars(self):
    """Guide user through environment variable setup"""
    print("📝 Step 1: Environment Variables")
    print("\nI'll help you create a .env file.\n")
    
    for var in self.required_env_vars:
        guidance = self.env_var_guidance.get(var, "")
        value = input(f"{var} ({guidance}): ").strip()
        self._write_to_env_file(var, value)
    
    print("\n✅ .env file created")

def _wizard_services(self):
    """Guide user through external service setup"""
    print("\n🔌 Step 2: External Services")
    
    for service in self.required_services:
        if not self._check_service(service):
            print(f"\n❌ {service['name']} is not reachable")
            print(f"💡 Suggested action: {service['setup_cmd']}")
            
            if input("Run this command now? (y/n): ").lower() == 'y':
                os.system(service['setup_cmd'])
                time.sleep(3)  # Wait for service to start
                
                if self._check_service(service):
                    print(f"✅ {service['name']} is now running")
                else:
                    print(f"⚠️ Please start {service['name']} manually")
```

---

## Integration with Application Lifecycle

### 1. Startup Validation (Always)

Every application should validate configuration **before** attempting to run:

```python
# main.py or app.py

from src.config_validator import ConfigValidator

def main():
    # ALWAYS validate first
    validator = ConfigValidator()
    
    if not validator.validate_all():
        print("\n❌ Configuration validation failed.")
        
        if input("Run setup wizard? (y/n): ").lower() == 'y':
            validator.run_setup_wizard()
        else:
            print("Please fix configuration issues and try again.")
            sys.exit(1)
    
    # Only proceed if validation passes
    print("✅ Configuration valid. Starting application...")
    run_application()
```

### 2. Health Check Endpoint (Web Apps)

```python
# For web applications, expose a health check endpoint

@app.route('/health')
def health_check():
    validator = ConfigValidator()
    results = validator.validate_all(detailed=True)
    
    if results['all_valid']:
        return {"status": "healthy", "details": results}, 200
    else:
        return {"status": "unhealthy", "details": results}, 503
```

### 3. CLI Command (Always)

```bash
# All applications should support:
python main.py --validate-config
python main.py --setup-wizard
```

---

## E2E Testing Requirements (All Four Layers)

Configuration validation MUST be comprehensively tested at all layers:

### Layer 1 Tests: Dependencies

```python
# tests/unit/test_config_validator_dependencies.py

def test_python_version_check():
    """Unit: Validate Python version requirement"""
    validator = ConfigValidator()
    checks = validator.validate_dependencies()
    assert checks['python_3.9+'] is True

def test_missing_dependency_detected():
    """Unit: Detect missing Python package"""
    # Mock missing package
    with mock.patch.dict('sys.modules', {'requests': None}):
        validator = ConfigValidator()
        checks = validator.validate_dependencies()
        assert checks['requests'] is False
```

### Layer 2 Tests: Configuration Values

```python
# tests/unit/test_config_validator_values.py

def test_missing_env_var_detected():
    """Unit: Detect missing env var"""
    with mock.patch.dict(os.environ, {}, clear=True):
        validator = ConfigValidator()
        checks = validator.validate_config_values()
        assert checks['DATABASE_URL_exists'] is False

def test_malformed_url_detected():
    """Unit: Detect malformed URL"""
    with mock.patch.dict(os.environ, {'DATABASE_URL': 'not-a-url'}):
        validator = ConfigValidator()
        checks = validator.validate_config_values()
        assert checks['DATABASE_URL_valid'] is False

def test_invalid_port_detected():
    """Unit: Detect invalid port number"""
    with mock.patch.dict(os.environ, {'PORT': '99999'}):
        validator = ConfigValidator()
        checks = validator.validate_config_values()
        assert checks['PORT_valid'] is False
```

### Layer 3 Tests: External Services (Integration)

```python
# tests/integration/test_config_validator_services.py

def test_database_connection_valid():
    """Integration: Test database connectivity with real test DB"""
    # Uses test database (docker-compose.test.yml)
    validator = ConfigValidator()
    checks = validator.validate_external_services()
    assert checks['database_connection'] is True

def test_database_connection_invalid():
    """Integration: Detect unreachable database"""
    with mock.patch.dict(os.environ, {'DATABASE_URL': 'postgresql://invalid:5432/db'}):
        validator = ConfigValidator()
        checks = validator.validate_external_services()
        assert checks['database_connection'] is False

def test_api_key_invalid():
    """Integration: Detect invalid API key"""
    with mock.patch.dict(os.environ, {'OPENAI_API_KEY': 'sk-invalid'}):
        validator = ConfigValidator()
        checks = validator.validate_external_services()
        assert checks['openai_api_key'] is False
```

### Layer 4 Tests: End-to-End Workflows (System)

```python
# tests/system/test_config_validator_workflows.py

def test_auth_workflow_e2e():
    """System: Test complete authentication workflow"""
    # Requires test user account (created in setup)
    validator = ConfigValidator()
    checks = validator.validate_e2e_workflows()
    assert checks['auth_workflow'] is True

def test_database_roundtrip_e2e():
    """System: Test write → read roundtrip"""
    validator = ConfigValidator()
    checks = validator.validate_e2e_workflows()
    assert checks['database_roundtrip'] is True

def test_api_integration_e2e():
    """System: Test external API integration"""
    # Tests full flow: fetch data, process, store
    validator = ConfigValidator()
    checks = validator.validate_e2e_workflows()
    assert checks['api_integration'] is True
```

### Comprehensive System Tests

```python
# tests/system/test_config_validation.py

def test_missing_env_var_detected():
    """System Test: App detects missing required env var"""
    # Arrange: Remove required env var
    env = os.environ.copy()
    del env['DATABASE_URL']
    
    # Act: Try to start app
    result = subprocess.run(
        ['python', 'main.py'],
        env=env,
        capture_output=True,
        text=True
    )
    
    # Assert: App fails gracefully with clear error
    assert result.returncode != 0
    assert "Missing required environment variables" in result.stderr
    assert "DATABASE_URL" in result.stderr

def test_invalid_database_connection_detected():
    """System Test: App detects invalid database connection"""
    # Arrange: Set invalid database URL
    env = os.environ.copy()
    env['DATABASE_URL'] = 'postgresql://invalid:5432/db'
    
    # Act: Try to start app
    result = subprocess.run(['python', 'main.py'], env=env, capture_output=True)
    
    # Assert: App fails with clear guidance
    assert result.returncode != 0
    assert "Cannot connect to database" in result.stderr
    assert "docker-compose up" in result.stderr  # Guidance provided

def test_setup_wizard_creates_valid_config():
    """System Test: Setup wizard generates working configuration"""
    # Arrange: Start with no config
    if os.path.exists('.env'):
        os.remove('.env')
    
    # Act: Run setup wizard with automated input
    input_data = "postgresql://localhost:5432/testdb\ntest-api-key\n"
    result = subprocess.run(
        ['python', 'main.py', '--setup-wizard'],
        input=input_data,
        capture_output=True,
        text=True
    )
    
    # Assert: .env created and app can start
    assert os.path.exists('.env')
    assert "Setup complete" in result.stdout
    
    # Verify app starts successfully
    result = subprocess.run(['python', 'main.py'], capture_output=True)
    assert result.returncode == 0

def test_health_check_reflects_config_status():
    """System Test: Health check endpoint validates config"""
    # Arrange: Start app with valid config
    app_process = start_app()
    time.sleep(2)
    
    # Act: Check health endpoint
    response = requests.get('http://localhost:8000/health')
    
    # Assert: Health check passes
    assert response.status_code == 200
    assert response.json()['status'] == 'healthy'
    
    # Cleanup
    app_process.terminate()

def test_test_account_creation_for_auth():
    """System Test: Test accounts can be created for auth testing"""
    # Arrange: Check if test user exists
    from src.auth import get_user
    test_email = os.getenv('TEST_USER_EMAIL', 'test@example.com')
    
    # Act: Create test user if doesn't exist
    if not get_user(test_email):
        result = subprocess.run(
            ['python', 'scripts/create_test_user.py', test_email],
            capture_output=True
        )
        assert result.returncode == 0
    
    # Assert: Test user exists and can authenticate
    test_pass = os.getenv('TEST_USER_PASSWORD', 'test123')
    from src.auth import authenticate_user
    token = authenticate_user(test_email, test_pass)
    assert token is not None

def test_all_layers_validated_on_startup():
    """System Test: All 4 validation layers run on startup"""
    # Act: Start app with full logging
    result = subprocess.run(
        ['python', 'main.py', '--verbose'],
        capture_output=True,
        text=True,
        timeout=10
    )
    
    # Assert: All layers validated
    assert "✅ Layer 1: Dependencies validated" in result.stdout
    assert "✅ Layer 2: Configuration values validated" in result.stdout
    assert "✅ Layer 3: External services validated" in result.stdout
    assert "✅ Layer 4: E2E workflows validated" in result.stdout
```

---

## Test Account Creation

For applications with authentication/authorization, a script to create test accounts MUST be provided:

```python
# scripts/create_test_user.py

import sys
import os
from src.auth import create_user
from src.data_layer import DataLayer

def create_test_user(email: str = None, password: str = None):
    """Create a test user for E2E testing"""
    email = email or os.getenv('TEST_USER_EMAIL', 'test@example.com')
    password = password or os.getenv('TEST_USER_PASSWORD', 'test123')
    
    print(f"Creating test user: {email}")
    
    # Check if user already exists
    db = DataLayer()
    existing = db.get_user_by_email(email)
    
    if existing:
        print(f"✅ Test user already exists: {email}")
        return existing
    
    # Create user with test role
    user = create_user(
        email=email,
        password=password,
        role='test_user',
        permissions=['read', 'write']
    )
    
    print(f"✅ Created test user: {email}")
    print(f"   Password: {password}")
    print(f"   Role: test_user")
    print(f"\nAdd to .env:")
    print(f"TEST_USER_EMAIL={email}")
    print(f"TEST_USER_PASSWORD={password}")
    
    return user

if __name__ == '__main__':
    email = sys.argv[1] if len(sys.argv) > 1 else None
    password = sys.argv[2] if len(sys.argv) > 2 else None
    create_test_user(email, password)
```

Usage:
```bash
# Create default test user
python scripts/create_test_user.py

# Create custom test user
python scripts/create_test_user.py test@myapp.com mypassword
```

---

## Configuration Documentation

Every application MUST generate `CONFIGURATION.md`:

```markdown
# Configuration Guide

## Required Environment Variables

| Variable | Description | Required | Default | Example |
|----------|-------------|----------|---------|---------|
| DATABASE_URL | PostgreSQL connection string | Yes | - | postgresql://localhost:5432/myapp |
| API_KEY | OpenAI API key | Yes | - | sk-... |
| LOG_LEVEL | Logging verbosity | No | INFO | DEBUG |
| TEST_USER_EMAIL | Test user for E2E tests | No (dev only) | test@example.com | test@myapp.com |
| TEST_USER_PASSWORD | Test user password | No (dev only) | test123 | secure_pass |

## External Services

### PostgreSQL Database
- **Purpose**: Application data storage
- **Setup**: `docker-compose up -d postgres`
- **Validation**: App checks connectivity on startup (Layer 3)
- **E2E Test**: Write → Read roundtrip validated (Layer 4)
- **Health Check**: `SELECT 1` query

### OpenAI API
- **Purpose**: LLM-powered features
- **Setup**: Get key from https://platform.openai.com/api-keys
- **Validation**: Test API call on startup (Layer 3)
- **E2E Test**: Full request → response → storage flow (Layer 4)
- **Rate Limits**: 10 req/min (free tier)

## Test Account Setup (For Auth/Authz Testing)

If this application uses authentication/authorization, you MUST create test accounts for E2E testing:

### Create Test User

```bash
# Option 1: Automated script
python scripts/create_test_user.py

# Option 2: Manual creation (via admin panel or direct DB)
# Follow instructions in scripts/create_test_user.py comments
```

### Test User Details

The test user is used by system/E2E tests to validate:
- Login workflow works end-to-end
- Protected resources are accessible with valid credentials
- Permission/role checks function correctly
- Token generation and validation works

**Default credentials** (can be overridden in .env):
- Email: `test@example.com`
- Password: `test123`
- Role: `test_user`
- Permissions: `['read', 'write']`

**Security**: Test accounts should ONLY exist in development/staging environments, never production.

## Setup Instructions

### First-Time Setup

```bash
# Option 1: Automated setup wizard (recommended)
python main.py --setup-wizard

# Option 2: Manual setup
cp .env.example .env
# Edit .env with your values
docker-compose up -d
python scripts/create_test_user.py  # If app uses auth
python main.py --validate-config
```

### Validation Layers

The application validates configuration in 4 layers on startup:

1. **Layer 1: Dependencies** - Verifies Python version, packages, system tools installed
2. **Layer 2: Config Values** - Checks env vars exist and are well-formed
3. **Layer 3: External Services** - Tests database/API connectivity and authentication
4. **Layer 4: E2E Workflows** - Validates complete workflows (auth, data roundtrip, integrations)

All layers must pass for the application to start.

### Troubleshooting

**Error: "Missing required environment variables"**
- Solution: Run `python main.py --setup-wizard`
- Or manually add missing vars to .env

**Error: "Cannot connect to database"**
- Solution: Ensure PostgreSQL is running: `docker-compose up -d postgres`
- Check connection string in .env
- Verify network connectivity: `psql $DATABASE_URL`

**Error: "Invalid API key"**
- Solution: Get valid key from https://platform.openai.com/api-keys
- Update API_KEY in .env
- Test: `curl -H "Authorization: Bearer $API_KEY" https://api.openai.com/v1/models`

**Error: "Auth workflow validation failed"**
- Solution: Create test user: `python scripts/create_test_user.py`
- Add TEST_USER_EMAIL and TEST_USER_PASSWORD to .env
- Verify test user can login: `python -c "from src.auth import authenticate_user; print(authenticate_user('test@example.com', 'test123'))"`

**Error: "Python version too old"**
- Solution: Upgrade Python to 3.9+
- Check: `python --version`
- Install: `pyenv install 3.11 && pyenv local 3.11`
```

---

## LEGO-Orchestrator Requirements

When building the `config_validator` LEGO, the LEGO-Orchestrator MUST:

1. **DESIGN**:
   - Identify all required configuration from other LEGOs
   - Define validation checks for each requirement
   - Design guided setup flow

2. **TEST AUTHORING**:
   - Unit tests for each validation function
   - Mock external services for unit tests

3. **CODING**:
   - Implement all validation checks
   - Implement setup wizard with clear prompts
   - Fail fast with actionable error messages

4. **VALIDATION**:
   - Run unit tests
   - **CRITICAL**: Run E2E system tests that verify:
     - Missing config is detected
     - Invalid config is detected
     - Setup wizard generates working config
     - Health checks reflect actual status

5. **DOCUMENTATION**:
   - Generate `CONFIGURATION.md` with all requirements
   - Include troubleshooting guide
   - Provide setup commands

---

## Integration with LEGO Discovery

In AGENTS.md Section 5 (LEGO Discovery), the meta-orchestrator MUST:

1. **Always generate a `config_validator` LEGO** (priority: critical)
2. **Extract configuration requirements from other LEGOs**:
   - Scan `external_services.md` for required services
   - Scan `.env.example` for required env vars
   - Scan `dependencies.md` for prerequisite software
3. **Make `config_validator` a dependency for all other implementation LEGOs**
   - Other LEGOs can assume config is valid (fail-fast principle)

---

## Benefits

✅ **Comprehensive**: 4-layer validation (dependencies → values → connectivity → workflows)  
✅ **Fail Fast**: Catch configuration errors before they cause mysterious failures  
✅ **Developer Experience**: Clear, actionable error messages with guidance  
✅ **Operations**: Health checks enable monitoring and auto-recovery  
✅ **Onboarding**: New users/operators get guided through setup  
✅ **Reliability**: Multi-layer tests ensure validation logic actually works  
✅ **Documentation**: CONFIGURATION.md generated automatically with test account guide  
✅ **Production Ready**: Auth/authz workflows validated end-to-end

---

## Example: Complete Flow (All 4 Layers)

```
User: python main.py

App: 🔍 Validating configuration...
     
     ✅ Layer 1: Dependencies
        ✅ Python 3.11.0 (>= 3.9 required)
        ✅ All Python packages installed
        ✅ docker command available
        ✅ psql command available
     
     ✅ Layer 2: Configuration Values
        ✅ DATABASE_URL present and well-formed
        ✅ API_KEY present and well-formed
        ✅ PORT valid (8000)
        ✅ config.json valid
     
     ⚠️ Layer 3: External Services
        ❌ PostgreSQL is not reachable
        ❌ Redis is not reachable
     
     💡 Suggested action: docker-compose up -d
     
     Run this command now? (y/n): y
     
     [Starting containers...]
     
     ✅ PostgreSQL is now running
     ✅ Redis is now running
     
     ✅ Layer 3: External Services (retry)
        ✅ PostgreSQL connection successful
        ✅ Redis connection successful
        ✅ OpenAI API key valid
     
     ✅ Layer 4: E2E Workflows
        ✅ Test user exists (test@example.com)
        ✅ Auth workflow validated (login → token → access)
        ✅ Database roundtrip validated (write → read)
        ✅ API integration validated (fetch → process → store)
     
     ✅ All validation layers passed!
     ✅ Configuration valid. Starting application...
     
     [App starts successfully]
```

---

## Summary

Every application built by the meta-cognitive pipeline MUST include:

1. **Configuration validation LEGO** (always generated, 4-layer approach)
   - Layer 1: Dependencies installed
   - Layer 2: Config values present & well-formed
   - Layer 3: External services reachable & authenticated
   - Layer 4: E2E workflows function correctly

2. **Startup validation** (fail fast with clear guidance)

3. **Guided setup wizard** (for first-time users/operators)

4. **Test account creation** (for auth/authz E2E testing)

5. **Comprehensive test coverage**:
   - Unit tests (Layers 1-2, with mocks)
   - Integration tests (Layer 3, with test services)
   - System/E2E tests (Layer 4, with real workflows)

6. **CONFIGURATION.md documentation** (auto-generated with troubleshooting)

7. **Health check endpoints** (for web apps)
6. Health check endpoints (for web apps)

This ensures applications are **production-ready** and **operator-friendly** out of the box.
