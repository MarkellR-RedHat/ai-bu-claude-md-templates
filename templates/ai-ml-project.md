# CLAUDE.md - AI/ML Project

## Project Overview

This is an AI/ML project. It may involve model training, fine-tuning, inference serving, or data pipeline work. The codebase follows standard Python conventions with additional considerations for GPU workloads, model artifacts, and reproducibility.

## Tech Stack

Common frameworks and tools used in this project:

- **Model Serving**: vLLM, TGI (Text Generation Inference), Triton Inference Server, KServe
- **ML Frameworks**: PyTorch, HuggingFace Transformers, TensorFlow (legacy)
- **Data Processing**: Pandas, Polars, Apache Spark
- **Experiment Tracking**: MLflow, Weights & Biases
- **Orchestration**: Kubeflow Pipelines, Airflow, Tekton
- **Container Runtime**: Podman, Docker
- **Platform**: Red Hat OpenShift, Red Hat OpenShift AI

## Code Conventions

### Python Style
- Follow PEP 8. Use `ruff` for linting and formatting.
- Use type hints on all function signatures.
- Use `pathlib.Path` instead of `os.path` for file path operations.
- Prefer `f-strings` over `.format()` or `%` string formatting.

### Model Code Organization
```
src/
  models/
    base.py          # Base model classes and interfaces
    inference.py     # Inference logic
    preprocessing.py # Input preprocessing and tokenization
  serving/
    server.py        # Model serving endpoints
    health.py        # Health check endpoints
  pipelines/
    training.py      # Training pipeline definitions
    evaluation.py    # Evaluation and benchmarking
  utils/
    gpu.py           # GPU detection and configuration
    logging.py       # Structured logging setup
configs/
  model_config.yaml
  serving_config.yaml
tests/
  unit/
  integration/
  fixtures/
```

### Configuration
- Use YAML for model and serving configuration files.
- Use environment variables for deployment-specific settings (GPU count, batch size, endpoints).
- Never hardcode model paths, API keys, or endpoint URLs.
- Use pydantic `BaseSettings` for configuration validation.

### Model Artifacts
- Do not commit model weights, checkpoints, or large datasets to git.
- Use `.gitignore` to exclude: `*.pt`, `*.bin`, `*.safetensors`, `*.gguf`, `checkpoints/`, `data/raw/`.
- Store model artifacts in S3-compatible storage (e.g., MinIO on OpenShift) or HuggingFace Hub.
- Document the model source, version, and license in a `MODEL_CARD.md` file.

## GPU-Aware Development

### Local Development
- Always check for GPU availability before assuming CUDA is present:
  ```python
  import torch
  device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
  ```
- Support CPU-only execution for development and testing. GPU should never be required to run the test suite.
- Use environment variables to control GPU allocation:
  ```bash
  CUDA_VISIBLE_DEVICES=0,1 python serve.py
  ```

### Testing on GPU
- Unit tests must run on CPU. Do not require a GPU for unit tests.
- Integration tests that require a GPU should be marked with `@pytest.mark.gpu` and skipped when no GPU is available.
- When testing inference, use small model variants (e.g., a tiny random-weight model) to keep test execution fast.

### Memory Management
- Monitor GPU memory usage, especially when loading large models.
- Use `torch.cuda.empty_cache()` judiciously, not as a fix for memory leaks.
- Profile memory usage with `torch.cuda.memory_summary()` during development.
- For multi-GPU setups, be explicit about tensor placement and data parallelism strategy.

## Inference Serving

### API Design
- Expose health check endpoints at `/health` and `/ready`.
- Use `/v1/completions` or `/v1/chat/completions` for OpenAI-compatible APIs when applicable.
- Return structured error responses with meaningful error codes.
- Include request ID in all responses for tracing.

### Performance
- Batch requests when possible. Document the batching strategy.
- Log inference latency (p50, p95, p99) and throughput metrics.
- Use async request handling for I/O-bound operations.
- Set appropriate timeouts for model loading and inference.

### Container Images
- Use Red Hat Universal Base Image (UBI) as the base image when deploying on OpenShift.
- Pin CUDA and cuDNN versions in the Dockerfile.
- Use multi-stage builds to keep the final image size reasonable.
- Include a non-root user in the container for security.

## Data Handling

- Never log or print PII, even during debugging.
- Validate input data before passing it to the model. Reject malformed inputs early.
- Document the expected input format and output schema.
- For training data, track provenance and licensing.

## Reproducibility

- Pin all dependency versions in `requirements.txt` or use `uv.lock`.
- Set random seeds for reproducible training:
  ```python
  torch.manual_seed(42)
  ```
- Log hyperparameters, training configuration, and hardware details with every experiment.
- Tag model versions with the git commit hash of the training code.

## Common Commands

```bash
# Install dependencies
pip install -e ".[dev]"

# Run linting
ruff check src/ tests/

# Run unit tests (no GPU required)
pytest tests/unit/ -v

# Run integration tests (GPU required)
pytest tests/integration/ -v -m gpu

# Start local inference server
python -m src.serving.server --config configs/serving_config.yaml

# Build container image
podman build -t model-server:latest .
```

## Environment Variables

| Variable              | Description                      | Default       |
|-----------------------|----------------------------------|---------------|
| `MODEL_PATH`          | Path to model weights            | (required)    |
| `CUDA_VISIBLE_DEVICES`| GPU device IDs to use           | all available |
| `BATCH_SIZE`          | Inference batch size             | 32            |
| `MAX_SEQ_LENGTH`      | Maximum input sequence length    | 2048          |
| `LOG_LEVEL`           | Logging verbosity                | INFO          |
| `PORT`                | Server port                      | 8080          |

## Review Checklist

Before merging changes:

- [ ] All unit tests pass on CPU
- [ ] No hardcoded paths, keys, or credentials
- [ ] Model artifacts are not committed to git
- [ ] GPU code has CPU fallback for testing
- [ ] Type hints are present on all public functions
- [ ] Configuration changes are documented
- [ ] Container image builds successfully
- [ ] Memory usage has been profiled for model-loading changes
