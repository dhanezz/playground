#!/bin/bash
#
# Author: E. Dhane Canupin
# Created: 25/02/2025
# Last Modified: 25/02/2025
# Version: 1.0
# Description: Script to calculate the profit of a stock investment. This is just a logic dump for upcoming projects.
# Usage: bash ./stock-profit-calculator.bash

### VARIABLES ###

CURRENCY="$"
tax_rate=0
avg_purchase_price=0
selling_price=0
quantity=0
leveraged=0

### FUNCTIONS ###

# Function to calculate the total investment
function calculate_total_investment() {
  total_investment=$(awk "BEGIN {printf \"%.2f\", $avg_purchase_price * $quantity}")
  echo "Total Investment: $CURRENCY$total_investment"
}

# Function to calculate the own capital
function calculate_own_capital() {
  own_capital=$(awk "BEGIN {printf \"%.2f\", $total_investment / $leveraged}")
  echo "Own Capital: $CURRENCY$own_capital"
}

# Function to calculate the total value
function calculate_total_value() {
  total_value=$(awk "BEGIN {printf \"%.2f\", $selling_price * $quantity}")
  echo "Total Value: $CURRENCY$total_value"
}

# Function to calculate the gross profit
function calculate_gross_profit() {
  gross_profit=$(awk "BEGIN {printf \"%.2f\", $total_value - $total_investment}")
  borrowed=$(awk "BEGIN {printf \"%.2f\", $total_investment - $own_capital}")
  echo "Gross Profit: $CURRENCY$gross_profit"

  if [ $leveraged -gt 0 ]; then
    echo "Borrowed: $CURRENCY$borrowed"
    cash_without_borrowed=$(awk "BEGIN {printf \"%.2f\", $total_value - $borrowed}")
    echo "Cash (without borrowed): $CURRENCY$cash_without_borrowed"
  fi
}

# Function to calculate the net profit
function calculate_net_profit() {
  net_profit=$(awk "BEGIN {printf \"%.2f\", $gross_profit - ($gross_profit * $tax_rate)}")
  echo "Net Profit: $CURRENCY$net_profit"
  
  if [ $leveraged -gt 0 ]; then
    net_cash_without_borrowed=$(awk "BEGIN {printf \"%.2f\", $cash_without_borrowed - ($cash_without_borrowed * $tax_rate)}")
    echo "Net Profit (without borrowed): $CURRENCY$net_cash_without_borrowed"
  fi
}

###### MAIN SCRIPT EXECUTION START #######
read -p "Enter the tax rate: " tax_rate
read -p "Enter the average purchase price: " avg_purchase_price
read -p "Enter the selling price: " selling_price
read -p "Enter the quantity: " quantity
read -p "Enter the leverage: " leveraged

# Display Results

echo "--------------------------------------"
echo "Tax Rate: $tax_rate"
echo "Average Purchase Price: $CURRENCY$avg_purchase_price"
echo "Selling Price: $CURRENCY$selling_price"
echo "Quantity: $quantity"
echo "Leverage: $leveraged" 
echo -e "\n"
calculate_total_investment

if [ $leveraged -eq 0 ]; then
  own_capital=$total_investment
  echo "Own Capital: $CURRENCY$total_investment"
else
  calculate_own_capital
fi

echo -e "\n"
calculate_total_value
calculate_gross_profit
calculate_net_profit
echo "--------------------------------------"
###### MAIN SCRIPT EXECUTION END #######
