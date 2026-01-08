// @ts-check
const { test, expect } = require('@playwright/test');

/**
 * E2E Tests for DevOps Assignment Frontend
 */

test.describe('Homepage', () => {
  test('should display the page title', async ({ page }) => {
    await page.goto('/');
    
    // Check that the main heading is visible
    const heading = page.locator('h1');
    await expect(heading).toBeVisible();
    await expect(heading).toHaveText('DevOps Assignment');
  });

  test('should have correct page title in browser tab', async ({ page }) => {
    await page.goto('/');
    
    // Check the browser tab title
    await expect(page).toHaveTitle('DevOps Assignment');
  });
});

test.describe('Backend Integration', () => {
  test('should display backend status section', async ({ page }) => {
    await page.goto('/');
    
    // Check that status section exists
    const statusSection = page.locator('.status');
    await expect(statusSection).toBeVisible();
    
    // Status text should contain "Status:"
    await expect(statusSection).toContainText('Status:');
  });

  test('should display message box section', async ({ page }) => {
    await page.goto('/');
    
    // Check that message box exists
    const messageBox = page.locator('.message-box');
    await expect(messageBox).toBeVisible();
    
    // Should have "Backend Message:" heading
    const messageHeading = messageBox.locator('h2');
    await expect(messageHeading).toHaveText('Backend Message:');
  });
});
