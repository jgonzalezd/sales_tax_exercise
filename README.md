# Sales Tax Challenge

This application calculates sales tax for a list of items and prints a formatted receipt. It is designed to solve the sales tax problem as described in the project requirements, adhering to Object-Oriented principles and a Test-Driven Development (TDD) methodology.

## Architectural Decisions

The architecture of this application was driven by a focus on simplicity, flexibility, and maintainability, while strictly avoiding over-engineering.

### 1. Test-Driven Development (TDD)

The entire project was developed using a TDD approach. Each feature began with a high-level "acceptance" test that defined the desired outcome from a business perspective.

*   **Initial Test**: I started with a single, failing acceptance test for the first sample input.
*   **Implementation**: I wrote the minimal amount of code required to make that test pass.
*   **Iteration**: This cycle was repeated for subsequent features, such as adding a command-line interface (CLI) and handling different tax scenarios.

I invite you to check the commit history to learn more about the process of creating this CLI app.

This TDD approach ensured that I only wrote code in response to a clear, tested requirement, which prevented unnecessary complexity and kept the design focused.

### 2. Evolution from Brittle to Robust Design

I made a significant architectural decision midway through the project to refactor the core logic for determining tax exemptions.

*   **Initial Approach (Keyword-based)**: The first implementation attempted to guess an item's tax category by searching for keywords (e.g., "book", "chocolate") in its name.
    *   **Problem**: This approach proved to be brittle and error-prone. It failed on edge cases (like a "notebook" could be incorrectly exempted because its name contained "book") and was not scalable to new types of goods (such like a "pregnancy test" would not be identified as a medical product). This approach violates the principle of being open for extension but closed for modification.

*   **Refactored Approach (Data-Driven)**: Recognizing these flaws, the design was pivoted to a more robust, data-driven model.
    *   **Solution**: I shifted the responsibility of categorization from the application to the input data itself. The JSON schema was updated to include an explicit `category` (`"book"`, `"food"`, `"medical"`, `"other"`) and a boolean `imported` flag for each item.
    *   **Benefit**: This change makes the system highly flexible and eliminates ambiguity. The `ReceiptGenerator` no longer performs fragile guesswork; instead it applies tax rules based on the explicit, data it receives, and the categorization responsibility relies on external system that provides the data. This is a superior design because it separates the data from the logic that acts on it, leading to a cleaner, more maintainable, and easily extendable system.

### 3. Simple Object-Oriented Structure

The code is organized into a few simple, plain Ruby objects, each with a clear responsibility:

*   `Item`: A simple data object that represents a single item in the  (quantity, name, price, category, etc.).
*   `Order`: Represents a collection of `Item` objects and knows how to build itself from the input JSON data.
*   `ReceiptGenerator`: A service object whose sole responsibility is to consume a `Order`, perform tax calculations, and produce a formatted receipt string. It contains all the business logic for taxes and rounding.

This separation of concerns prevents the creation of a single monolithic do-it-all class that violates Single Resposibility Principle.

## Testing Strategy

The testing strategy is centered on **acceptance tests** rather than fine-grained unit tests.

*   **Why Acceptance Tests?**: The primary goal is to verify that the application produces the correct final output for a given input. By testing the entire process from JSON input to formatted-string output, I ensure the system works as a whole. This approach has the added benefit of not being tightly coupled to the internal implementation details of any single class. When I refactored the `ReceiptGenerator`, our acceptance tests remained valid and provided a safety net to ensure the new implementation was correct.

*   **Test Coverage**: The test suite (`spec/acceptance_receipt_spec.rb` and `spec/cli_spec.rb`) covers every scenario described in the requirements:
    *   Tax-exempt goods (books, food, medical).
    *   Non-exempt goods.
    *   Imported goods (both exempt and non-exempt).
    *   The specific rounding rule (rounding up to the nearest 0.05).
    *   Correct calculation of totals and sales taxes.

## Trade-offs

*   **Configuration**: Tax rates (`10%`, `5%`) and exempt categories are currently hardcoded as constants in the `ReceiptGenerator`. For this exercise, this is a reasonable simplification. In a real-world, production application, these values would likely be moved to a configuration file or a database to allow for changes without modifying and redeploying the application code.


## Overview
This project implements a solution for calculating sales tax on purchased items based on specific rules.

## Setup
1. Install dependencies:
```
bundle install
```
2. Ensure the CLI script is executable (usually already is):
```
chmod +x bin/receipt
```

## CLI Usage
Run the receipt generator by passing a path to a JSON file describing the order:
```
bin/receipt <path-to-json>
```
Alternatively, you can invoke it with Ruby:
```
ruby bin/receipt <path-to-json>
```

### Input JSON format
The file should contain an `items` array. Each item requires `quantity`, `name`, `price`, `category`, and `imported`:
```json
{
  "items": [
    { "quantity": 2, "name": "book", "price": 12.49, "category": "book", "imported": false },
    { "quantity": 1, "name": "music CD", "price": 14.99, "category": "other", "imported": false },
    { "quantity": 1, "name": "chocolate bar", "price": 0.85, "category": "food", "imported": false }
  ]
}
```

### Assumptions
- **category**: One of `book`, `food`, `medical`, `other`. Used to determine basic tax exemption.
- **imported**: Boolean indicating whether the item is imported. Import duty is applied only when this is `true`. The displayed `name` may still contain the word "imported", but tax logic relies on this boolean.
- **quantity**: Integer ≥ 1.
- **price**: Decimal number; calculations round up taxes to the nearest 0.05 and totals to two decimals.

### Example
```
bin/receipt input1.json
```
Sample output for the above input:
```
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

### Errors
- Missing argument prints usage and exits:
```
Usage: receipt <path-to-json>
```
- Nonexistent file prints an error and exits:
```
File not found: <path>
```

## Testing
To ensure the accuracy of the sales tax calculations, run the test suite with the following command:
```
bundle exec rspec
```
This will execute all test cases to verify the functionality of the application.
