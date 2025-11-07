# MathsWallah

MathsWallah is a minimal FastAPI application that returns a random integer from 1 to 1000.
This project includes everything to run locally, build a Docker image, and deploy on a k3s cluster.

## Project layout
- `app/main.py` - FastAPI application code (endpoints: `/` and `/random`)
- `requirements.txt` - Python dependencies
- `Dockerfile` - Docker build instructions
- `.dockerignore` - ignore files for Docker context
- `k8s/namespace.yaml` - Kubernetes Namespace manifest
- `k8s/deployment.yaml` - Kubernetes Deployment manifest (2 replicas)
- `k8s/service.yaml` - Kubernetes Service (NodePort) to expose the app on node port 30080

## How to build and run locally (Docker)
1. Build the image (on your machine or on your k3s node):
   ```bash
   docker build -t mathswallah:latest .
   ```
2. Run the container:
   ```bash
   docker run -d --name mathswallah -p 8000:8000 mathswallah:latest
   ```
3. Test the API from your laptop (if running on remote VM, replace `localhost` with VM IP):
   ```bash
   curl http://localhost:8000/random
   ```

## How to deploy on k3s (single-node)
1. Copy the docker image to the k3s node and build the image there OR push to a registry that k3s can pull from.
   - Option A (build on k3s node):
     ```bash
     # on the k3s node
     docker build -t mathswallah:latest /path/to/project
     ```
   - Option B (push to registry):
     ```bash
     docker tag mathswallah:latest registry.example.com/yourrepo/mathswallah:1.0.0
     docker push registry.example.com/yourrepo/mathswallah:1.0.0
     # update k8s/deployment.yaml image field accordingly and set imagePullPolicy: IfNotPresent or Always
     ```
2. Apply manifests (from any machine with KUBECONFIG pointing at the k3s cluster, or on the k3s host):
   ```bash
   kubectl apply -f k8s/namespace.yaml
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml
   ```
3. Verify pods and service:
   ```bash
   kubectl -n mathswallah get pods -o wide
   kubectl -n mathswallah get svc mathswallah-svc -o wide
   ```
4. Access the API from your laptop (replace <NODE_IP> with k3s node IP):
   ```bash
   curl http://<NODE_IP>:30080/random
   ```

## Notes
- The k8s Deployment uses `imagePullPolicy: IfNotPresent` so it's convenient to build the image directly on the k3s node for local testing.
- If port `30080` is in use on your node, adjust `nodePort` in `k8s/service.yaml`.
