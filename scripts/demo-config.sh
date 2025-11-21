#!/bin/bash
# Demo Kit Configuration - Immutable Configuration Values
# DO NOT EDIT AT RUNTIME - This file is the source of truth for demo kit configuration
# To update versions, edit this file and commit changes

# Package version to install
readonly PACKAGE_VERSION="2.2.1"

# Git repository configuration
readonly DEMO_COMMIT="cb149a8b228004ac94100eb507fd362e0ff65c89"
readonly DEMO_BRANCH="demo/example-project"

# Metadata
readonly CREATED_DATE="2025-11-21"

# Export for child processes
export PACKAGE_VERSION DEMO_COMMIT DEMO_BRANCH CREATED_DATE

# Validation function
validate_config() {
    local errors=0

    if [ -z "$PACKAGE_VERSION" ]; then
        echo "❌ Error: PACKAGE_VERSION not set" >&2
        errors=$((errors + 1))
    fi

    if [ -z "$DEMO_COMMIT" ]; then
        echo "❌ Error: DEMO_COMMIT not set" >&2
        errors=$((errors + 1))
    fi

    if [ -z "$DEMO_BRANCH" ]; then
        echo "❌ Error: DEMO_BRANCH not set" >&2
        errors=$((errors + 1))
    fi

    return $errors
}

# Run validation if this script is sourced
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    # Script is being sourced
    validate_config
fi
