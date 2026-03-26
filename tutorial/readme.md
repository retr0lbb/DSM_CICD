# Bidirectional GitHub ↔ GitLab Sync Tutorial

This tutorial explains how to sync a GitLab repository with a GitHub repository in both directions.

## Prerequisites

- A GitLab account with a repository
- A GitHub account with a repository (or create one)

---

## Step 1: Create GitHub Personal Access Token

1. Go to https://github.com/settings/tokens
2. Click **Generate new token (classic)**
3. **Note**: `gitlab-sync`
4. **Expiration**: Choose any, i choosed 6 months
5. **Scopes**: Check `repo` and `workflow`
6. Click **Generate token**
7. **Copy and save the token immediately, The token will not be visible again**

---

## Step 2: Set Up GitLab Push Mirroring (GitLab → GitHub)

1. Go to your GitLab repository → **Settings** → **Repository**
2. Scroll to **Mirroring repositories**
3. Click **Add new**
4. Fill in:
   - **Git repository URL**: `https://github.com/YOUR_USERNAME/YOUR_REPO.git`
   - **Username**: `oauth2`
   - **Password**: Your GitHub Personal Access Token
5. Click **Add mirror**

---

## Step 3: Create GitHub Actions Workflow (GitHub → GitLab)

### Add GitHub Secrets

1. Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret** and add:
   - **Name**: `GITLAB_TOKEN`
   - **Secret**: Your GitLab Personal Access Token
3. Add another secret:
   - **Name**: `GITLAB_REPO`
   - **Secret**: `your-gitlab-username/your-gitlab-repo`

### Create Workflow File

1. Create the file `.github/workflows/sync-to-gitlab.yml` in your repository
2. Add this content:

```yaml
name: Sync to GitLab

on:
  push:
    branches:
      - main
      - master
  delete:
    branches:
      - main
      - master

permissions:
  contents: read

jobs:
  sync-to-gitlab:
    runs-on: ubuntu-latest
    if: ${{ !contains(github.event.head_commit.message, '[skip-gitlab-sync]') }}
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Push to GitLab
        env:
          GITLAB_TOKEN: ${{ secrets.GITLAB_TOKEN }}
          GITLAB_REPO: ${{ secrets.GITLAB_REPO }}
        run: |
          git remote add gitlab "https://gitlab-ci-token:${GITLAB_TOKEN}@gitlab.com/${GITLAB_REPO}.git"
          git push gitlab ${{ github.ref }} --force
```

---

## Step 4: Create GitLab Personal Access Token

1. Go to https://gitlab.com/-/profile/personal_access_tokens
2. **Token name**: `github-sync`
3. **Expiration**: Choose any
4. **Scopes**: Check `api` and `write_repository`
5. Click **Create personal access token**
6. **Copy and save the token**

---

## Step 5: Add Secrets to GitHub

1. Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**
2. Add these secrets:
   - `GITLAB_TOKEN`: Your GitLab PAT
   - `GITLAB_REPO`: `your-gitlab-username/your-gitlab-repo`

---

## Testing

1. **GitLab → GitHub**: Push to GitLab → should appear on GitHub
2. **GitHub → GitLab**: Push to GitHub → should appear on GitLab

## Skipping Sync

To skip sync for a specific commit, include `[skip-gitlab-sync]` in your commit message.

---

## Troubleshooting

### 403 Permission Denied
- Make sure your GitHub token has `repo` and `workflow` scopes
- Make sure the token was created by the GitHub account that owns the repository

### Workflow file rejected
- The GitHub token needs `workflow` scope to push changes to `.github/workflows/` files

### Infinite loop
- The workflow already includes a check to skip commits with `[skip-gitlab-sync]`
- GitLab push mirroring is one-way, so it won't cause loops from the GitLab side
