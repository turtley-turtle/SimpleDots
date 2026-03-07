#!/usr/bin/env python3

# Wrong password!

import random

# Randomized texts

wrong = [
    "Wrong!",
    "Nope.",
    "Better luck next time!",
    "Nuh uh",
    "TOTALLY... WRONG!",
    "You'll never guess it!",
    "You are incorrect.",
    "Did you try 123456?",
    "Maybe it's ABC123",
    "Why you trynna steal a Linux PC bruh?"
]

# Pick a random text

print(random.choice(wrong))

# This was supposed to change the password error text in my Hyprlock but
# Hyprlock doesn't support command outputs as error text.
# I'll just it leave it here to whoever wants to use it.