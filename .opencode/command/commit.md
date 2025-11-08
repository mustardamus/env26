---
description: Lint, Format and Git Commit changed files
---

First run the lint command `make lint` successfully, then run the format
command `make format` successfully.

Then commit the code changes following these rules:

- Use imperative mood ("Add feature" not "Added feature")
- Be extremely concise while remaining informative
- Focus on what changed and why, not how
- Group related changes into single bullet points when logical
- Prioritize the most significant changes first
- Format as multiple bullet points only if needed - if you can sum up changes in
  one line, do it:
  - First line: Concise summary of the overall theme (50 characters or less)
  - Blank line
  - Bullet points: Specific changes, each starting with a dash and space
- Never use emojis or special characters
- Avoid redundant or obvious statements
- Don't include implementation details unless critical

Run `git add . && git commit -m "commit message"` in one command.

After the commit is successful, output "Committed :)"
