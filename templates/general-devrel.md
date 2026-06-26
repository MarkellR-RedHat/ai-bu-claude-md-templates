# CLAUDE.md - General Developer Relations Project

## Project Overview

This is a Developer Relations project. It may include code samples, demos, tutorials, workshop materials, documentation, or community tooling. The primary audience is external developers, and everything produced here should be clear, runnable, and genuinely helpful.

## Dev Rel Principles

- **Developer-first**: Every piece of content exists to help developers succeed. If it does not help them build something, rethink it.
- **Honest and practical**: Do not oversell. Show real trade-offs. Developers respect honesty about limitations.
- **Runnable by default**: Every code sample, demo, and tutorial must work out of the box. If there are prerequisites, document them explicitly.
- **Community-oriented**: Engage with the community authentically. Respond to issues and PRs with empathy and context.

## Code Sample Standards

### Every code sample must include:
1. A `README.md` explaining what it does, who it is for, and how to run it.
2. Clear prerequisites (language version, tools, accounts needed).
3. Step-by-step setup instructions that a developer can follow without guessing.
4. Expected output or screenshots showing what success looks like.
5. A license file (Apache 2.0 is standard for Red Hat open source projects).

### Code quality:
- Code samples are production-quality examples, not throwaway scripts. Write them as if a developer will copy them directly into their project, because they will.
- Include error handling. Do not use bare `except` clauses in Python or ignore errors in Go.
- Add comments explaining "why," not "what." The code shows what. Comments explain decisions.
- Keep dependencies minimal. Every additional dependency is a potential point of failure.
- Pin dependency versions. `pip install flask` today and `pip install flask` six months from now may give different results.

### Repository structure for code samples:
```
sample-name/
  README.md
  LICENSE
  src/
    main.py (or main.go, index.js, etc.)
  tests/
  Containerfile (or Dockerfile)
  Makefile
  requirements.txt (or go.mod, package.json, etc.)
```

## Documentation Standards

- Write for scanning, not reading. Developers scan docs looking for the thing they need.
- Use headers, bullet points, and code blocks liberally. Walls of text lose people.
- Start every doc with the "what" and "why" before the "how."
- Include a table of contents for docs longer than three sections.
- Test all documented commands and procedures before publishing.
- Date your content. Technology moves fast, and readers need to know if instructions are current.

### Formatting rules:
- Use sentence case for all headers: "Getting started with OpenShift" not "Getting Started With OpenShift."
- Do not use em dashes. Use commas, periods, or "and" instead.
- Use backtick formatting for all CLI commands, file paths, environment variables, and code references.
- Use admonitions (Note, Warning, Important) sparingly. If everything is a warning, nothing is.

## Workshop and Tutorial Design

### Structure:
1. **Overview**: What will participants build? What will they learn? (2-3 sentences)
2. **Prerequisites**: Exact versions, tools, and accounts. Link to installation guides.
3. **Steps**: Numbered, with clear start and end points. Each step should take 5-15 minutes.
4. **Checkpoints**: After each major section, describe what the participant should see if everything worked.
5. **Troubleshooting**: Common issues and their solutions. These save workshop facilitators hours.
6. **Cleanup**: How to tear down resources created during the workshop. This is mandatory for cloud resources.

### Workshop best practices:
- Test the workshop end-to-end on a clean machine before delivering it.
- Assume the WiFi will fail. Have offline fallbacks for anything that requires downloads.
- Build in buffer time. Workshops always run longer than you expect.
- Provide a "fast path" for experienced participants who want to skip ahead.

## Community Interaction

### GitHub Issues and PRs:
- Respond to new issues within 2 business days, even if the response is "we've seen this and will investigate."
- Label issues consistently: `bug`, `enhancement`, `question`, `good-first-issue`, `help-wanted`.
- When closing issues, explain why and link to relevant resources.
- Review community PRs with the same rigor as internal PRs. Provide constructive feedback.
- Thank contributors. A simple "Thanks for the PR!" goes a long way.

### Writing for community:
- Use inclusive language. Avoid terms with exclusionary history.
- Write in English, but keep language simple for non-native speakers.
- Do not assume the reader's operating system, IDE, or experience level unless stated.
- When giving feedback on community contributions, be specific and constructive. "This doesn't work" is unhelpful. "This fails on Python 3.12 because of X" is actionable.

## Demo Guidelines

- Demos should tell a story: problem, solution, result.
- Keep demos under 10 minutes for conference talks, under 5 minutes for booth demos.
- Have a pre-recorded backup of every live demo. Live demos fail at the worst possible time.
- Script your demo steps. Practice them at least three times.
- Use a clean, distraction-free terminal and browser for demos. Close Slack, email, and notifications.

## Red Hat Brand Guidelines

- Use correct product names (see content-writing.md for the full reference).
- Follow Red Hat brand guidelines for presentations and visual materials.
- When creating content about upstream projects, focus on the community project name. Reference Red Hat products separately.
- Include appropriate disclaimers when showing pre-release or tech preview features.

## Analytics and Measurement

- Track key metrics for content: page views, time on page, GitHub stars, forks, and issue activity.
- Set goals for each piece of content. "Awareness" is not measurable. "500 unique visitors in the first month" is.
- Review analytics quarterly and retire or update content that is underperforming or outdated.

## Review Checklist

Before publishing:

- [ ] All code samples run without errors on a clean setup
- [ ] README includes prerequisites, setup steps, and expected output
- [ ] Links are valid and point to current resources
- [ ] Product names follow Red Hat conventions
- [ ] Content has been reviewed by at least one other person
- [ ] License file is included (Apache 2.0)
- [ ] No credentials, API keys, or internal URLs in the content
