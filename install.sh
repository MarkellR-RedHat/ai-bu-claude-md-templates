#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="${SCRIPT_DIR}/templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo ""
echo -e "${BOLD}CLAUDE.md Template Installer${NC}"
echo "============================================"
echo ""

# Check that templates directory exists
if [ ! -d "${TEMPLATES_DIR}" ]; then
    echo -e "${RED}Error: templates directory not found at ${TEMPLATES_DIR}${NC}"
    exit 1
fi

# List available templates
echo -e "${BOLD}Available templates:${NC}"
echo ""

templates=()
index=1

for template in "${TEMPLATES_DIR}"/*.md; do
    if [ -f "${template}" ]; then
        filename=$(basename "${template}" .md)
        # Extract the first heading as a description
        description=$(head -1 "${template}" | sed 's/^# CLAUDE.md - //')
        templates+=("${template}")
        echo -e "  ${BLUE}${index})${NC} ${BOLD}${filename}${NC}"
        echo "     ${description}"
        echo ""
        index=$((index + 1))
    fi
done

if [ ${#templates[@]} -eq 0 ]; then
    echo -e "${RED}Error: No template files found in ${TEMPLATES_DIR}${NC}"
    exit 1
fi

# Prompt for selection
echo -e "${BOLD}Select a template (1-${#templates[@]}):${NC} "
read -r selection

# Validate selection
if ! [[ "${selection}" =~ ^[0-9]+$ ]] || [ "${selection}" -lt 1 ] || [ "${selection}" -gt ${#templates[@]} ]; then
    echo -e "${RED}Error: Invalid selection. Please enter a number between 1 and ${#templates[@]}.${NC}"
    exit 1
fi

selected_template="${templates[$((selection - 1))]}"
selected_name=$(basename "${selected_template}" .md)

echo ""
echo -e "Selected: ${GREEN}${selected_name}${NC}"
echo ""

# Prompt for target directory
echo -e "${BOLD}Enter the target directory (where CLAUDE.md will be created):${NC}"
echo -e "  Press Enter to use the current directory ($(pwd))"
read -r target_dir

if [ -z "${target_dir}" ]; then
    target_dir="$(pwd)"
fi

# Expand ~ to home directory
target_dir="${target_dir/#\~/$HOME}"

# Resolve to absolute path
target_dir="$(cd "${target_dir}" 2>/dev/null && pwd)" || {
    echo -e "${RED}Error: Directory '${target_dir}' does not exist.${NC}"
    exit 1
}

target_file="${target_dir}/CLAUDE.md"

# Check if CLAUDE.md already exists
if [ -f "${target_file}" ]; then
    echo ""
    echo -e "${RED}Warning: ${target_file} already exists.${NC}"
    echo -e "${BOLD}Overwrite? (y/N):${NC} "
    read -r overwrite
    if [[ ! "${overwrite}" =~ ^[Yy]$ ]]; then
        echo "Aborted. No files were changed."
        exit 0
    fi
fi

# Copy the template
cp "${selected_template}" "${target_file}"

echo ""
echo -e "${GREEN}Done.${NC} CLAUDE.md has been created at:"
echo "  ${target_file}"
echo ""
echo "Next steps:"
echo "  1. Open ${target_file} in your editor"
echo "  2. Update the Project Overview section"
echo "  3. Customize the template for your specific project"
echo ""
