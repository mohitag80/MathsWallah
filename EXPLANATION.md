Explanation of each file in the MathsWallah project

1) app/main.py
   - The FastAPI application.
   - Two endpoints:
     * GET /      -> returns a small JSON welcome message (used for readiness/liveness probes)
     * GET /random -> returns a JSON object {"number": <random int 1..1000>}
   - Uses Python's random.randint for deterministic randomness per call.

2) requirements.txt
   - Lists Python packages required to run the app: FastAPI and Uvicorn.

3) Dockerfile
   - Base image: python:3.11-slim for small footprint and compatibility.
   - Copies requirements.txt, installs deps.
   - Copies app code and creates a non-root user `appuser` for security.
   - Exposes port 8000 and runs uvicorn to serve the FastAPI app.

4) .dockerignore
   - Files and directories excluded from Docker build context to keep image lean.

5) k8s/namespace.yaml
   - Creates the `mathswallah` namespace in Kubernetes to isolate resources.

6) k8s/deployment.yaml
   - Declares a Deployment named `mathswallah` with 2 replicas.
   - Uses image: mathswallah:latest and `imagePullPolicy: IfNotPresent` to facilitate local builds on k3s node.
   - Includes resource requests/limits and health probes (readiness/liveness).
   - For production, update image to a registry-hosted tag and use appropriate security contexts and resource sizing.

7) k8s/service.yaml
   - Defines a NodePort Service to expose the app on node port 30080 so you can curl from your laptop:
     http://<NODE_IP>:30080/random
   - NodePort is convenient for single-node and development clusters like k3s.

8) README.md
   - Quick start instructions for building, running, and deploying the app.

Deployment notes / k3s specifics:
- For k3s, local image builds are simplest: build the docker image directly on the k3s host so the `IfNotPresent` policy picks it up.
- Alternatively, push to a registry and change the Deployment image to reference the registry image and set imagePullPolicy appropriately.

