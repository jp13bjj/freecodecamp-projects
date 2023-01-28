import copy
import random
# Consider using the modules imported above.

class Hat:
  def __init__(self,**contents):
    self.contents = [k for k, v in contents.items() for x in range(v)]

  def __str__(self):
    return str(self.contents)

  def draw(self,num_draws):
    draws = []
    if num_draws > len(self.contents):
      draws = self.contents
      self.contents = []
    else:
      for i in range(num_draws):
        draw_index = random.randrange(len(self.contents))
        ball_drawn = self.contents.pop(draw_index)
        draws.append(ball_drawn)
    return draws 
    



def experiment(hat, expected_balls, num_balls_drawn, num_experiments):
  # number of failed experiments
  F = 0
  # Looping through experiments
  for N in range(num_experiments):
    #failed = False
    another_hat = copy.deepcopy(hat)
    draws = another_hat.draw(num_balls_drawn)
    draw_freq = {x:draws.count(x) for x in set(draws)}
    
    for j in list(expected_balls.keys()):
      if j in draw_freq:
        if draw_freq[j] >= expected_balls[j]:
          continue
        else:
          F += 1
          #failed = True
          break
      else:
        F += 1
        #failed = True
        break
  M = num_experiments - F
  prob = M/num_experiments
  return prob
