#!/usr/bin/env bash
set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Cleanup trap to remove any leftover .tmp files on exit or interruption
cleanup_all_tmp() {
	# Find and remove any .tmp files created by this script
	find . -name "*.tmp" -type f -delete 2>/dev/null || true
}

# Set trap to cleanup on exit, interrupt, or termination
trap cleanup_all_tmp EXIT INT TERM

# Parse .gitignore and build exclude patterns
parse_gitignore() {
	local gitignore_file="${1:-.gitignore}"
	local patterns=()

	# Always exclude .git
	patterns+=(".git")

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
			if [[ "$file" == $pattern ]]; then
				return 0
			fi
			;;
		*\*)
			# Pattern with wildcard like *.log or temp*
			if [[ "$file" == $pattern || "$file" == */"$pattern" ]]; then
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
			if [[ "$file" == */"$pattern"/* || "$file" == */"$pattern" || "$file" == "./$pattern"/* || "$file" == "./$pattern" ]]; then
				return 0
			fi
			;;
		esac
	done

	return 1
}

# Format a single file based on extension
format_file() {
	local file="$1"
	local ext="${file##*.}"
	local basename="${file##*/}"
	local formatted=false
	local tmpfile="${file}.tmp"

	# Cleanup function for temp files
	cleanup_tmp() {
		if [ -f "$tmpfile" ]; then
			rm -f "$tmpfile"
		fi
	}

	# Handle special files without extensions
	case "$basename" in
	Dockerfile* | Containerfile* | *.dockerfile | *.containerfile)
		if command -v dockerfmt &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(dockerfile)${NC}"
			if dockerfmt <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} dockerfmt failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} dockerfmt not found, skipping $file"
		fi
		return
		;;
	Caddyfile)
		# Caddyfile doesn't have a standard formatter in the config
		echo -e "${YELLOW}Skipping${NC} $file (no formatter configured)"
		return
		;;
	esac

	# Format based on extension
	case "$ext" in
	toml)
		if command -v taplo &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(toml)${NC}"
			if taplo fmt - <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} taplo failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} taplo not found, skipping $file"
		fi
		;;
	sh | bash)
		if command -v shfmt &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(bash)${NC}"
			if shfmt -w "$file" 2>/dev/null; then
				formatted=true
			else
				echo -e "${RED}Error:${NC} shfmt failed on $file"
			fi
		else
			echo -e "${RED}Warning:${NC} shfmt not found, skipping $file"
		fi
		;;
	md)
		if command -v prettier &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(markdown)${NC}"
			if prettier --stdin-filepath "file.md" <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} prettier failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} prettier not found, skipping $file"
		fi
		;;
	json)
		if command -v prettier &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(json)${NC}"
			if prettier --stdin-filepath "file.json" <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} prettier failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} prettier not found, skipping $file"
		fi
		;;
	yaml | yml)
		if command -v prettier &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(yaml)${NC}"
			if prettier --stdin-filepath "file.yaml" <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} prettier failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} prettier not found, skipping $file"
		fi
		;;
	html)
		if command -v prettier &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(html)${NC}"
			if prettier --stdin-filepath "file.html" <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} prettier failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} prettier not found, skipping $file"
		fi
		;;
	css)
		if command -v prettier &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(css)${NC}"
			if prettier --stdin-filepath "file.css" <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} prettier failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} prettier not found, skipping $file"
		fi
		;;
	ts | tsx)
		if command -v prettier &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(typescript)${NC}"
			if prettier --stdin-filepath "file.ts" <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} prettier failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} prettier not found, skipping $file"
		fi
		;;
	js | jsx | mjs | cjs)
		if command -v prettier &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(javascript)${NC}"
			if prettier --stdin-filepath "file.js" <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} prettier failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${RED}Warning:${NC} prettier not found, skipping $file"
		fi
		;;
	astro)
		if command -v prettier &>/dev/null; then
			local astro_plugin="/home/dev/.local/share/mise/installs/npm-prettier-plugin-astro/latest/lib/node_modules/prettier-plugin-astro/dist/index.js"
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(astro)${NC}"

			# Check if plugin exists, fall back to plugin name if not
			if [ -f "$astro_plugin" ]; then
				if prettier --stdin-filepath "file.astro" --plugin "$astro_plugin" <"$file" >"$tmpfile" 2>/dev/null; then
					mv "$tmpfile" "$file"
					formatted=true
				else
					echo -e "${RED}Error:${NC} prettier failed on $file"
					cleanup_tmp
				fi
			else
				# Fallback to plugin name (might work if installed globally)
				if prettier --stdin-filepath "file.astro" --plugin prettier-plugin-astro <"$file" >"$tmpfile" 2>/dev/null; then
					mv "$tmpfile" "$file"
					formatted=true
				else
					echo -e "${RED}Error:${NC} prettier failed on $file (plugin not found at $astro_plugin)"
					cleanup_tmp
				fi
			fi
		else
			echo -e "${RED}Warning:${NC} prettier not found, skipping $file"
		fi
		;;
	fish)
		if command -v fish_indent &>/dev/null; then
			echo -e "${BLUE}Formatting${NC} $file ${YELLOW}(fish)${NC}"
			if fish_indent <"$file" >"$tmpfile" 2>/dev/null; then
				mv "$tmpfile" "$file"
				formatted=true
			else
				echo -e "${RED}Error:${NC} fish_indent failed on $file"
				cleanup_tmp
			fi
		else
			echo -e "${YELLOW}Skipping${NC} $file (fish_indent not found)"
		fi
		;;
	kdl)
		# KDL doesn't have a standard formatter
		echo -e "${YELLOW}Skipping${NC} $file (no formatter configured for kdl)"
		;;
	*)
		# Skip files without recognized extensions
		;;
	esac

	if [ "$formatted" = true ]; then
		echo -e "${GREEN}✓${NC} Formatted $file"
	fi
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
		echo -e "${BLUE}Formatting all files in project...${NC}\n"

		# Find all files
		while IFS= read -r -d '' file; do
			# Check if file should be excluded
			if ! should_exclude "$file" "${gitignore_patterns[@]}"; then
				files+=("$file")
			fi
		done < <(find . -type f -print0)
	else
		echo -e "${BLUE}Formatting changed and uncommitted files...${NC}\n"

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

		# If no files to format
		if [ ${#files[@]} -eq 0 ]; then
			echo -e "${GREEN}No files to format!${NC}"
			exit 0
		fi
	fi

	echo -e "${YELLOW}Found ${#files[@]} file(s) to process${NC}\n"

	# Format each file
	local count=0
	for file in "${files[@]}"; do
		if [ -f "$file" ]; then
			format_file "$file"
			((count++)) || true
		fi
	done

	echo ""
	echo -e "${GREEN}✓ Done!${NC} Processed $count file(s)"
}

# Show usage
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
	echo "Usage: $0 [all]"
	echo ""
	echo "Format files according to Helix configuration"
	echo ""
	echo "Arguments:"
	echo "  (none)    Format only changed and uncommitted files"
	echo "  all       Format all files in the project"
	echo ""
	echo "Supported formats:"
	echo "  - TOML (taplo)"
	echo "  - Bash/Shell (shfmt)"
	echo "  - Markdown (prettier)"
	echo "  - JSON (prettier)"
	echo "  - YAML (prettier)"
	echo "  - HTML (prettier)"
	echo "  - CSS (prettier)"
	echo "  - TypeScript/TSX (prettier)"
	echo "  - JavaScript/JSX (prettier)"
	echo "  - Astro (prettier)"
	echo "  - Dockerfile (dockerfmt)"
	echo "  - Fish (fish_indent)"
	exit 0
fi

main "$@"
