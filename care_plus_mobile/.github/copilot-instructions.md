# Care Plus Mobile - Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview

This is a Flutter mobile healthcare management application called "Care Plus" that supports three user roles: Patients, Doctors, and Caregivers. The app focuses on medication management, scheduling, health monitoring, and secure communication.

## Architecture Guidelines

- Use Clean Architecture with Repository pattern
- Implement MVVM/Provider or Riverpod for state management
- Follow SOLID principles and dependency injection
- Use feature-based folder structure
- Implement offline-first approach with data synchronization

## Key Features to Consider

- Role-based authentication (Patient, Doctor, Caregiver)
- Comprehensive medication management with scheduling
- Push notifications and local alarms for medication reminders
- Health vitals tracking and monitoring
- Secure communication between users
- HIPAA compliance and data encryption
- Offline functionality with sync capabilities

## Security Requirements

- Implement JWT token-based authentication
- Use encrypted local storage for sensitive data
- Follow HIPAA compliance guidelines
- Implement certificate pinning for API calls
- Use biometric authentication where possible

## Coding Standards

- Follow Dart/Flutter best practices
- Use meaningful variable and function names
- Write comprehensive unit and widget tests
- Implement proper error handling and logging
- Use const constructors where possible
- Follow Flutter's material design guidelines

## Database Integration

- Use PostgreSQL backend with REST API
- Implement proper caching strategies
- Handle offline data persistence
- Use proper data models with serialization

## Performance Considerations

- Implement lazy loading for large datasets
- Optimize image loading and caching
- Use efficient state management
- Minimize widget rebuilds
- Implement proper memory management
