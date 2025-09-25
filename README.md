# Sales Tax Challenge

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
The file should contain an `items` array. Each item requires `quantity`, `name`, and `price`:
```json
{
  "items": [
    { "quantity": 2, "name": "book", "price": 12.49 },
    { "quantity": 1, "name": "music CD", "price": 14.99 },
    { "quantity": 1, "name": "chocolate bar", "price": 0.85 }
  ]
}
```

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
