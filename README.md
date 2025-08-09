# Blockchain-Based Public Art and Craft Services Regulation

A comprehensive smart contract system for regulating and managing public art and craft services using Clarity on the Stacks blockchain.

## Overview

This system provides decentralized regulation and management for five key areas of public art and craft services:

1. **Art Restoration Licensing** - Issues and manages permits for painting and artwork restoration services
2. **Custom Framing Certification** - Manages licenses for picture framing and art mounting services
3. **Art Supply Quality Standards** - Ensures art materials meet safety and quality requirements
4. **Gallery and Exhibition Coordination** - Manages art shows and exhibitions in public spaces
5. **Art Education Program Management** - Coordinates art classes and workshops in community centers

## Smart Contracts

### 1. Art Restoration Licensing (`art-restoration-licensing.clar`)
- Issues restoration permits with expiration dates
- Tracks licensed restorers and their specializations
- Manages permit renewals and revocations
- Maintains restoration project records

### 2. Custom Framing Certification (`custom-framing-certification.clar`)
- Certifies framing professionals
- Manages certification levels and specializations
- Tracks certification renewals
- Records framing project completions

### 3. Art Supply Quality Standards (`art-supply-quality-standards.clar`)
- Registers art supply vendors
- Manages quality certifications for materials
- Tracks safety compliance
- Handles quality complaints and resolutions

### 4. Gallery and Exhibition Coordination (`gallery-exhibition-coordination.clar`)
- Schedules gallery spaces and exhibitions
- Manages artist applications and approvals
- Coordinates exhibition logistics
- Tracks visitor engagement and feedback

### 5. Art Education Program Management (`art-education-program.clar`)
- Registers qualified instructors
- Schedules classes and workshops
- Manages student enrollments
- Tracks program completion and certifications

## Key Features

- **Decentralized Governance**: Community-driven decision making for regulations
- **Transparent Operations**: All licensing and certification activities are recorded on-chain
- **Automated Compliance**: Smart contracts enforce regulatory requirements automatically
- **Immutable Records**: Permanent record of all certifications, licenses, and activities
- **Public Accessibility**: Anyone can verify credentials and compliance status

## Data Structures

Each contract maintains specific data structures for:
- Professional credentials and certifications
- Project records and completion status
- Quality standards and compliance metrics
- Scheduling and coordination information
- Financial transactions and fee payments

## Security Features

- Multi-signature requirements for critical operations
- Time-locked administrative functions
- Automated expiration handling
- Fraud prevention mechanisms
- Emergency pause functionality

## Getting Started

1. Deploy contracts to Stacks testnet/mainnet
2. Initialize contract parameters and admin roles
3. Register initial service providers
4. Begin issuing licenses and certifications
5. Monitor compliance and manage renewals

## Testing

The system includes comprehensive test suites using Vitest to ensure:
- Contract functionality works as expected
- Edge cases are handled properly
- Security measures are effective
- Integration between contracts is seamless

## Governance

The system supports decentralized governance through:
- Community voting on regulatory changes
- Transparent fee structure management
- Democratic selection of oversight committees
- Public dispute resolution processes
