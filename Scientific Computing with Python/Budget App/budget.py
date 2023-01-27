class Category:
  def __init__(self,name):
      self.ledger = []
      self.name = name
      self.balance = 0

  def __repr__(self):
    display = self.name.center(30,'*')+'\n'
    for items in self.ledger:
      display += f"{items['description'][:23]:23}" + f"{items['amount']:7.2f}" + '\n'
    display += f"Total: {self.get_balance():.2f}"
    return display
  
  def deposit(self,amount,description = ''):
    self.ledger.append({'amount':amount, 'description':description})
    self.balance += amount

  def withdraw(self,amount,description = ''):
    if self.check_funds(amount) == False:
      return False
    else:
      self.ledger.append({'amount':-amount, 'description':description})
      self.balance -= amount
      return True
      
  def get_balance(self):
    return self.balance

  def transfer(self,amount,budget_category):
    if self.check_funds(amount) == False:
      return False
    else:
      self.withdraw(amount, f"Transfer to {budget_category.name}")
      budget_category.deposit(amount, f"Transfer from {self.name}")
      return True

  def check_funds(self,amount):
    return not amount > self.balance
      


def create_spend_chart(categories):
  output = "Percentage spent by category\n"

  # Retrieve total expense of each category
  total = 0
  expenses = []
  names = []
  len_names = 0

  for item in categories:
    expense = sum([-x['amount'] for x in item.ledger if x['amount'] < 0])
    total += expense

    if len(item.name) > len_names:
      len_names = len(item.name)

    expenses.append(expense)
    names.append(item.name)
  
  # Convert to percent + pad labels
  expenses = [(x/total)*100 for x in expenses]
  names   = [name.ljust(len_names, " ") for name in names]
  
  # Format output
  for i in range(100,-1,-10):
    output += str(i).rjust(3, " ") + '|'
    for x in expenses:
      output += " o " if x >= i else "   "
    output += " \n"
  
  # Add each category name
  output += "    " + "---"*len(names) + "-\n"
  
  for i in range(len_names):
    output += "    "
    for name in names:
      output += " " + name[i] + " "
    output += " \n"

  return output.strip("\n")