# IMDS Interview Assessment App

A SwiftUI-based interview assessment application focused on data-science question practice and progress tracking.

## Highlights

- Multiple assessment and difficulty levels
- CSV-driven question banks
- Timed test sessions and answer tracking
- Per-test and aggregate statistics
- Accuracy and completion summaries
- Profile and achievement views
- Reward/life mechanics and advertising integration points
- Optional AI-assisted explanations through the OpenAI API
- Email and utility helpers
- SwiftUI architecture with view models and reusable components

## Project Structure

- `interviewApp/interviewApp/views/` - SwiftUI screens and reusable views
- `interviewApp/interviewApp/viewModels/` - test, profile, statistics, achievement, and advertising logic
- `interviewApp/interviewApp/data/` - CSV-backed question data, persistence, and data-management logic
- `interviewApp/interviewApp/utils/` - CSV, email, AI, timing, and utility helpers
- `interviewApp/interviewAppTests/` - unit-test target
- `interviewApp/interviewAppUITests/` - UI-test target

## AI Configuration

The repository does not contain an API key. For local development, `ChatGPT.swift` reads `OPENAI_API_KEY` from the process environment.

For a production iOS application, model-provider credentials should not be embedded in the client application. Route authenticated API calls through a server-side backend or another secure credential-management layer.

## Repository Notes

This repository is retained as a software-engineering portfolio project. Xcode user state, build artifacts, macOS metadata, local configuration, and secrets are intentionally excluded from version control.
