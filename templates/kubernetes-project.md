# CLAUDE.md - Kubernetes / OpenShift Project

## Project Overview

This is a Kubernetes-native project. It may include Helm charts, operators, custom controllers, CRDs, or deployment manifests targeting Kubernetes and Red Hat OpenShift clusters.

## Tech Stack

- **Container Runtime**: Podman (preferred on Red Hat systems), Docker
- **Orchestration**: Kubernetes, Red Hat OpenShift
- **Package Management**: Helm, Kustomize
- **Operator Framework**: Operator SDK, controller-runtime, kubebuilder
- **CI/CD**: Tekton, GitHub Actions, OpenShift Pipelines
- **Testing**: kind, minikube, OpenShift Local (formerly CRC)
- **Languages**: Go (operators and controllers), Python (scripts and tooling), Bash (automation)

## Project Structure

```
project-root/
  api/
    v1alpha1/          # CRD type definitions
      types.go
      zz_generated.deepcopy.go
  cmd/
    manager/
      main.go          # Operator entrypoint
  config/
    crd/
      bases/           # Generated CRD manifests
    manager/           # Deployment manifests for the operator
    rbac/              # RBAC rules
    samples/           # Example CRs
  controllers/
    myresource_controller.go
  deploy/
    helm/
      Chart.yaml
      values.yaml
      templates/
    kustomize/
      base/
      overlays/
        dev/
        staging/
        production/
  hack/               # Development scripts
  tests/
    e2e/
```

## Naming Conventions

### CRDs and Custom Resources
- CRD group should use a domain you control: `myproject.example.com`
- CRD names follow the pattern: `<plural>.<group>` (e.g., `inferencservices.serving.example.com`)
- Kind names are PascalCase and singular: `InferenceService`, not `inferenceservice` or `InferenceServices`
- API versions follow Kubernetes conventions: `v1alpha1`, `v1beta1`, `v1`

### Labels and Annotations
- Use the standard Kubernetes label prefixes:
  ```yaml
  app.kubernetes.io/name: my-app
  app.kubernetes.io/version: "1.0.0"
  app.kubernetes.io/component: frontend
  app.kubernetes.io/part-of: my-platform
  app.kubernetes.io/managed-by: helm
  ```
- Custom labels should use your project domain: `myproject.example.com/environment: production`
- Do not use unprefixed labels except for `app` and `version` for backward compatibility.

### Resource Names
- Use lowercase with hyphens: `my-deployment`, not `myDeployment` or `my_deployment`
- Keep names under 63 characters (Kubernetes label value limit).
- Be descriptive: `model-inference-server` not `server1`

## Helm Chart Conventions

- Follow the [Helm best practices](https://helm.sh/docs/chart_best_practices/) guide.
- Use `values.yaml` for all configurable parameters. Do not hardcode values in templates.
- Provide sensible defaults in `values.yaml` with comments explaining each parameter.
- Include `NOTES.txt` with post-install instructions.
- Use `_helpers.tpl` for reusable template functions.
- Test charts with `helm lint` and `helm template` before committing.
- Pin image tags in `values.yaml`. Never default to `latest`.

## Operator Development

### Controller Best Practices
- Controllers should be idempotent. Running reconciliation multiple times with the same input should produce the same result.
- Use `controller-runtime`'s built-in retry and rate-limiting. Do not implement your own retry loops.
- Set appropriate RBAC permissions. Follow the principle of least privilege.
- Add finalizers when your controller creates external resources that need cleanup.
- Use status conditions to communicate resource state:
  ```yaml
  status:
    conditions:
      - type: Ready
        status: "True"
        reason: DeploymentAvailable
        message: "All replicas are available"
  ```

### Error Handling
- Return `ctrl.Result{RequeueAfter: time.Minute}` for transient errors that should be retried.
- Return `ctrl.Result{}` (empty) when reconciliation is complete and no requeue is needed.
- Log errors with structured logging. Include the resource namespace and name.
- Do not panic in controllers. Handle all errors gracefully.

## RBAC

- Define RBAC rules in `config/rbac/` using `kubebuilder` markers:
  ```go
  //+kubebuilder:rbac:groups=myproject.example.com,resources=myresources,verbs=get;list;watch;create;update;patch;delete
  //+kubebuilder:rbac:groups=myproject.example.com,resources=myresources/status,verbs=get;update;patch
  ```
- Never grant `cluster-admin` to an operator. Request only the permissions you need.
- Use `Role` and `RoleBinding` for namespace-scoped resources. Use `ClusterRole` and `ClusterRoleBinding` only for cluster-scoped resources.

## Testing

### Unit Tests
- Mock the Kubernetes API client using `controller-runtime`'s `fake` client.
- Test reconciliation logic with various resource states (created, updated, deleted, error conditions).
- Use table-driven tests for validation logic.

### Integration Tests
- Use `envtest` from controller-runtime for integration tests that need a real API server.
- For full cluster tests, use `kind` (Kubernetes in Docker) in CI.
- For OpenShift-specific features, use OpenShift Local or a shared development cluster.

### End-to-End Tests
- E2E tests should create resources, wait for the expected state, and clean up.
- Use a dedicated test namespace. Clean up the namespace after tests.
- Set reasonable timeouts for polling resource status.

```bash
# Create a kind cluster for testing
kind create cluster --name test-cluster

# Run unit tests
go test ./... -v -short

# Run integration tests with envtest
make test

# Run e2e tests against a cluster
make test-e2e

# Lint Helm charts
helm lint deploy/helm/

# Template Helm chart for review
helm template my-release deploy/helm/ --values deploy/helm/values.yaml
```

## Container Images

- Use Red Hat Universal Base Image (UBI) as the base:
  ```dockerfile
  FROM registry.access.redhat.com/ubi9/ubi-minimal:latest
  ```
- Build with Podman when possible: `podman build -t my-image:v1.0.0 .`
- Use multi-stage builds to minimize image size.
- Run as non-root. Set `USER 1001` in the Dockerfile.
- For OpenShift compatibility, do not assume the container runs as a specific UID.

## OpenShift-Specific Notes

- OpenShift uses Routes instead of Ingress (though Ingress is also supported).
- Security Context Constraints (SCCs) restrict what pods can do. Test with `restricted-v2` SCC.
- Use OpenShift's built-in image registry for development: `image-registry.openshift-image-registry.svc:5000`
- DeploymentConfig is deprecated. Use standard Kubernetes Deployments.

## Common Mistakes to Avoid

- Do not use `kubectl` commands in automation scripts without checking the exit code.
- Do not assume a namespace exists. Create it or check for it first.
- Do not hardcode cluster-specific values (domain names, registry URLs) in manifests.
- Do not use em dashes in any documentation or comments. Use commas, periods, or "and" instead.
- Do not commit kubeconfig files or service account tokens to git.

## Review Checklist

Before merging:

- [ ] CRD naming follows Kubernetes conventions
- [ ] Helm chart passes `helm lint`
- [ ] RBAC follows least privilege principle
- [ ] Controller is idempotent
- [ ] Unit tests pass
- [ ] No hardcoded cluster-specific values
- [ ] Container runs as non-root
- [ ] Resource requests and limits are set in deployment manifests
- [ ] Status conditions are set for custom resources
