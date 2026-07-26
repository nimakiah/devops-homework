# Problem 3: Dockerized Status HTTP Server

A simple Flask HTTP web server containerized using Docker.

## Endpoint API Spec
- **path** '/api/v1/status'
- **GET**: Returns '{"status":"<current_status>"}' with HTTP '200'. Default status is '"OK"'.
- **POST**: Accepts `{"status": "<new_status>"}` and updates memory state, returning `{"status": "<new_status>"}` with HTTP `201`.

---

## How to Build and Run with Docker

### 1. Build Docker Image
```bash
docker build -t status-server:v1 .
```

### 2. Run Container and Publish Port
```bash
docker run -d -p 8000:8000 --name my-status-app status-server:v1
```

### 3. Test the API
#### Check initial GET status:
```bash
curl -X GET http://localhost:8000/api/v1/status
```
#### Output: {"status":"OK"}

#### Update status with POST:
```bash
curl -X POST http://localhost:8000/api/v1/status \
     -H "Content-Type: application/json" \
     -d '{"status": "not OK"}'
```
#### Output: {"status":"not OK"}

#### Verify updated GET status:
```bash
curl -X GET http://localhost:8000/api/v1/status
```
#### Output: {"status":"not OK"}


