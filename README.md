# CLAUDE.md Templates

A collection of ready-to-use CLAUDE.md template files for different project types.

## What is CLAUDE.md?

CLAUDE.md is a file you place in your project's root directory to give [Claude Code](https://docs.anthropic.com/en/docs/claude-code) context about your project. It tells Claude about your coding conventions, project structure, testing approaches, and how to work effectively in your codebase. Think of it as onboarding documentation for your AI coding assistant.

When Claude Code opens a project, it reads the CLAUDE.md file and uses that context to generate better, more project-appropriate code and suggestions.

## Available Templates

| Template | File | Best For |
|----------|------|----------|
| Content Writing | `templates/content-writing.md` | Blog posts, technical articles, and content projects. Includes Red Hat tone guidelines, product name conventions, blog structure patterns, and link formatting rules. |
| Conference Proposals | `templates/proposals.md` | CFP submissions and talk proposals. Includes abstract structure, learning objectives, audience targeting, and speaker bio formatting. Covers KubeCon, Red Hat Summit, DevConf, and more. |
| AI/ML Project | `templates/ai-ml-project.md` | Machine learning and AI codebases. Covers model serving with vLLM and KServe, GPU-aware testing, inference pipelines, PyTorch conventions, and container image best practices. |
| Kubernetes Project | `templates/kubernetes-project.md` | Kubernetes and OpenShift projects. Includes Helm chart conventions, operator patterns, CRD naming rules, RBAC best practices, and testing with kind and envtest. |
| General Dev Rel | `templates/general-devrel.md` | Developer Relations work. Covers code sample standards, documentation guidelines, workshop design, demo best practices, and community interaction patterns. |
| Go Project | `templates/go-project.md` | Go codebases. Includes Go naming conventions, error handling patterns, concurrency guidelines, testing with table-driven tests, and container image builds. |
| Python Project | `templates/python-project.md` | Python codebases. Covers type hints, pytest conventions, dependency management with uv and pip, Pydantic models, ruff linting, and virtual environment handling. |

## Quick Start

### Option 1: Use the install script

```bash
git clone https://github.com/MarkellR-RedHat/ai-bu-claude-md-templates.git
cd ai-bu-claude-md-templates
chmod +x install.sh
./install.sh
```

The script will show you the available templates, let you pick one, and copy it to a directory of your choice.

### Option 2: Copy manually

```bash
# Copy a template directly into your project
cp templates/python-project.md /path/to/your/project/CLAUDE.md
```

### Option 3: Use curl (no clone needed)

```bash
# Download a single template directly
curl -o CLAUDE.md https://raw.githubusercontent.com/MarkellR-RedHat/ai-bu-claude-md-templates/main/templates/python-project.md
```

## Customizing a Template

After copying a template into your project, customize it:

1. Update the **Project Overview** section with a description of your specific project.
2. Adjust the **Tech Stack** to match what your project actually uses.
3. Modify **Project Structure** to reflect your real directory layout.
4. Add or remove conventions based on your team's practices.
5. Update **Common Commands** with the actual commands for your project.

The templates are starting points, not rigid specifications. Remove what does not apply and add what is missing.

## Contributing

Contributions are welcome. If you have a template for a project type not covered here, open a PR. Each template should be:

- Complete enough to be useful out of the box
- Specific enough to provide real guidance (not generic placeholder text)
- Written in a direct, practical voice
- Free of hardcoded project-specific details that every user would need to change

## License

Apache License 2.0
