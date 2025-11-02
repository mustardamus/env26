#!/usr/bin/env bash
set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Track if any lint errors were found
LINT_ERRORS=0

# Parse .gitignore and build exclude patterns
parse_gitignore() {
	local gitignore_file="${1:-.gitignore}"
	local patterns=()

	# Always exclude .git and .opencode
	patterns+=(".git")
	patterns+=(".opencode")

	# Read .gitignore if it exists
	if [ -f "$gitignore_file" ]; then
		while IFS= read -r line; do
			# Skip empty lines and comments
			[[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

			# Remove leading/trailing whitespace using bash parameter expansion
			line="${line#"${line%%[![:space:]]*}"}" # Remove leading whitespace
			line="${line%"${line##*[![:space:]]}"}" # Remove trailing whitespace

			# Skip if empty after trimming
			[[ -z "$line" ]] && continue

			# Skip negation patterns (!)
			[[ "$line" =~ ^! ]] && continue

			# Remove trailing slashes
			line="${line%/}"

			# Add to patterns
			patterns+=("$line")
		done <"$gitignore_file"
	fi

	printf '%s\n' "${patterns[@]}"
}

# Check if a file should be excluded based on gitignore patterns
should_exclude() {
	local file="$1"
	shift
	local patterns=("$@")

	for pattern in "${patterns[@]}"; do
		# Handle different pattern types
		case "$pattern" in
		\**)
			# Glob pattern like **/*.log
			if [[ "$file" == "$pattern" ]]; then
				return 0
			fi
			;;
		*\*)
			# Pattern with wildcard like *.log or temp*
			if [[ "$file" == "$pattern" || "$file" == */"$pattern" ]]; then
				return 0
			fi
			;;
		*/*)
			# Path pattern like foo/bar
			if [[ "$file" == *"$pattern"* ]]; then
				return 0
			fi
			;;
		*)
			# Simple directory or file name
			if [[ "$file" == */"$pattern"/* || "$file" == */"$pattern" || "$file" == "./$pattern"/* || "$file" == "./$pattern" || "$file" == "$pattern"/* || "$file" == "$pattern" ]]; then
				return 0
			fi
			;;
		esac
	done

	return 1
}

# Lint a single file based on extension
lint_file() {
	local file="$1"
	local ext="${file##*.}"
	local basename="${file##*/}"
	local linted=false
	local errors=0
	local linter_name=""
	local output=""

	# Handle special files without extensions
	case "$basename" in
	Caddyfile)
		if command -v caddy &>/dev/null; then
			linter_name="caddy"
			echo -e "${GRAY}---start: $linter_name - $file---${NC}"
			output=$(caddy validate --config "$file" 2>&1) || errors=1
			if [ -n "$output" ]; then
				echo "$output"
			fi
			if [ "$errors" -eq 1 ]; then
				echo -e "${RED}✗${NC} Lint errors found in $file"
				((LINT_ERRORS++)) || true
			else
				echo -e "${GREEN}✓${NC} No lint errors in $file"
			fi
			echo -e "${GRAY}---end: $linter_name - $file---${NC}"
			echo ""
			linted=true
		else
			echo -e "${YELLOW}Skipping${NC} $file (caddy not found)"
		fi
		return
		;;
	esac

	# Lint based on extension
	case "$ext" in
	sh | bash)
		if command -v shellcheck &>/dev/null; then
			linter_name="shellcheck"
			echo -e "${GRAY}---start: $linter_name - $file---${NC}"
			output=$(shellcheck "$file" 2>&1) || errors=1
			if [ -n "$output" ]; then
				echo "$output"
			fi
			if [ "$errors" -eq 1 ]; then
				echo -e "${RED}✗${NC} Lint errors found in $file"
				((LINT_ERRORS++)) || true
			else
				echo -e "${GREEN}✓${NC} No lint errors in $file"
			fi
			echo -e "${GRAY}---end: $linter_name - $file---${NC}"
			echo ""
			linted=true
		else
			echo -e "${YELLOW}Skipping${NC} $file (shellcheck not found)"
		fi
		;;
	md)
		if command -v markdownlint-cli2 &>/dev/null; then
			linter_name="markdownlint-cli2"
			echo -e "${GRAY}---start: $linter_name - $file---${NC}"
			output=$(markdownlint-cli2 "$file" 2>&1) || errors=1
			if [ -n "$output" ]; then
				echo "$output"
			fi
			if [ "$errors" -eq 1 ]; then
				echo -e "${RED}✗${NC} Lint errors found in $file"
				((LINT_ERRORS++)) || true
			else
				echo -e "${GREEN}✓${NC} No lint errors in $file"
			fi
			echo -e "${GRAY}---end: $linter_name - $file---${NC}"
			echo ""
			linted=true
		else
			echo -e "${YELLOW}Skipping${NC} $file (markdownlint-cli2 not found)"
		fi
		;;
	json)
		if command -v jq &>/dev/null; then
			linter_name="jq"
			echo -e "${GRAY}---start: $linter_name - $file---${NC}"
			output=$(jq empty "$file" 2>&1) || errors=1
			if [ -n "$output" ]; then
				echo "$output"
			fi
			if [ "$errors" -eq 1 ]; then
				echo -e "${RED}✗${NC} Lint errors found in $file"
				((LINT_ERRORS++)) || true
			else
				echo -e "${GREEN}✓${NC} No lint errors in $file"
			fi
			echo -e "${GRAY}---end: $linter_name - $file---${NC}"
			echo ""
			linted=true
		else
			echo -e "${YELLOW}Skipping${NC} $file (jq not found)"
		fi
		;;
	toml)
		if command -v taplo &>/dev/null; then
			linter_name="taplo"
			echo -e "${GRAY}---start: $linter_name - $file---${NC}"
			output=$(taplo check "$file" 2>&1) || errors=1
			if [ -n "$output" ]; then
				echo "$output"
			fi
			if [ "$errors" -eq 1 ]; then
				echo -e "${RED}✗${NC} Lint errors found in $file"
				((LINT_ERRORS++)) || true
			else
				echo -e "${GREEN}✓${NC} No lint errors in $file"
			fi
			echo -e "${GRAY}---end: $linter_name - $file---${NC}"
			echo ""
			linted=true
		else
			echo -e "${YELLOW}Skipping${NC} $file (taplo not found)"
		fi
		;;
	yaml | yml)
		if command -v yq &>/dev/null; then
			linter_name="yq"
			echo -e "${GRAY}---start: $linter_name - $file---${NC}"
			output=$(yq eval "$file" 2>&1 >/dev/null) || errors=1
			if [ -n "$output" ]; then
				echo "$output"
			fi
			if [ "$errors" -eq 1 ]; then
				echo -e "${RED}✗${NC} Lint errors found in $file"
				((LINT_ERRORS++)) || true
			else
				echo -e "${GREEN}✓${NC} No lint errors in $file"
			fi
			echo -e "${GRAY}---end: $linter_name - $file---${NC}"
			echo ""
			linted=true
		else
			echo -e "${YELLOW}Skipping${NC} $file (yq not found)"
		fi
		;;
	ts | tsx | js | jsx | mjs | cjs | astro)
		# TypeScript/JavaScript files will be checked by tsc below
		# Just mark as linted to show we processed it
		linted=true
		;;
	*)
		# Skip files without recognized extensions
		;;
	esac

	if [ "$linted" = true ] && [ "$errors" -eq 0 ] && [ -z "$linter_name" ]; then
		echo -e "${GREEN}✓${NC} No lint errors in $file"
	fi
}

# Run TypeScript type checking
run_typescript_check() {
	local mode="$1"
	local output=""
	local errors=0

	# Check if tsconfig.json exists
	if [ ! -f "tsconfig.json" ]; then
		return
	fi

	# Check if tsc is available
	if ! command -v tsc &>/dev/null; then
		echo -e "${YELLOW}Skipping TypeScript type checking (tsc not found)${NC}"
		return
	fi

	echo ""
	echo -e "${GRAY}---start: tsc - TypeScript type checking---${NC}"
	output=$(tsc --noEmit 2>&1) || errors=1
	if [ -n "$output" ]; then
		echo "$output"
	fi
	if [ "$errors" -eq 0 ]; then
		echo -e "${GREEN}✓${NC} No type errors found"
	else
		echo -e "${RED}✗${NC} TypeScript type errors found"
		((LINT_ERRORS++)) || true
	fi
	echo -e "${GRAY}---end: tsc - TypeScript type checking---${NC}"
	echo ""
}

# Main logic
main() {
	local mode="${1:-changed}"
	local files=()
	local gitignore_patterns

	# Parse .gitignore patterns
	mapfile -t gitignore_patterns < <(parse_gitignore ".gitignore")

	echo -e "${YELLOW}Loaded ${#gitignore_patterns[@]} exclusion patterns from .gitignore${NC}"

	if [ "$mode" = "all" ]; then
		echo -e "${BLUE}Linting all files in project...${NC}\n"

		# Find all files
		while IFS= read -r -d '' file; do
			# Check if file should be excluded
			if ! should_exclude "$file" "${gitignore_patterns[@]}"; then
				files+=("$file")
			fi
		done < <(find . -type f -print0)
	else
		echo -e "${BLUE}Linting changed and uncommitted files...${NC}\n"

		# Check if we're in a git repository
		if ! git rev-parse --git-dir &>/dev/null; then
			echo -e "${RED}Error:${NC} Not in a git repository"
			exit 1
		fi

		# Get modified, added, and untracked files
		while IFS= read -r file; do
			# Skip empty lines
			[ -z "$file" ] && continue

			# Skip if file doesn't exist (could be deleted)
			[ ! -f "$file" ] && continue

			# Check if file should be excluded
			if should_exclude "$file" "${gitignore_patterns[@]}"; then
				continue
			fi

			files+=("$file")
		done < <(git status --porcelain | awk '{print $2}')

		# If no files to lint
		if [ ${#files[@]} -eq 0 ]; then
			echo -e "${GREEN}No files to lint!${NC}"
			exit 0
		fi
	fi

	echo -e "${YELLOW}Found ${#files[@]} file(s) to process${NC}\n"

	# Lint each file
	local count=0
	for file in "${files[@]}"; do
		if [ -f "$file" ]; then
			lint_file "$file"
			((count++)) || true
		fi
	done

	# Run TypeScript type checking
	run_typescript_check "$mode"

	echo ""
	if [ "$LINT_ERRORS" -eq 0 ]; then
		echo -e "${GREEN}✓ Done!${NC} Processed $count file(s) - No errors found"
		exit 0
	else
		echo -e "${RED}✗ Done!${NC} Processed $count file(s) - $LINT_ERRORS error(s) found"
		exit 1
	fi
}

# Show usage
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
	echo "Usage: $0 [all]"
	echo ""
	echo "Lint files to check for errors and code quality issues"
	echo ""
	echo "Arguments:"
	echo "  (none)    Lint only changed and uncommitted files"
	echo "  all       Lint all files in the project"
	echo ""
	echo "Supported linters:"
	echo "  - TypeScript/JavaScript (tsc type checking)"
	echo "  - Bash/Shell (shellcheck)"
	echo "  - Markdown (markdownlint-cli2)"
	echo "  - JSON (jq)"
	echo "  - TOML (taplo)"
	echo "  - YAML (yq)"
	echo "  - Caddyfile (caddy validate)"
	echo ""
	echo "Exit codes:"
	echo "  0  No lint errors found"
	echo "  1  Lint errors found"
	exit 0
fi

main "$@"
