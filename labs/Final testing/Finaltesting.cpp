#include <iostream>

// Define the structure
struct Item {
    int value;
};

// Function to count elements greater than a threshold
int countGreaterThan(Item* arr, int size, int threshold) {
    int count = 0;  // Initialize count to 0
    for (int i = 0; i < size; i++) {
        if (arr[i].value > threshold) {
            count++;  // Increment count if condition is satisfied
        }
    }
    return count;  // Return the count
}

// Example usage
int main() {
    Item items[] = {{10}, {20}, {30}, {40}, {50}};
    int size = sizeof(items) / sizeof(items[0]);
    int threshold = 25;
    std::cout << "Count: " << countGreaterThan(items, size, threshold) << std::endl;
    return 0;
}
