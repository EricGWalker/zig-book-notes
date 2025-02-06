with open("puzzle_input.txt") as file:
    column_1 = []
    column_2 = []
    for line in file:
        column_1 += [int(line[0:5])]
        column_2 += [int(line[8:13])]

    column_1.sort()
    column_2.sort()
    
    problem_1 = 0
    for col1, col2 in zip(column_1, column_2):
        problem_1 += abs(col1 - col2)
    print(f"Problem 1 answer is {problem_1}")

    map = {}
    for col1 in column_1:
        map[col1] = 0
    for col2 in column_2:
        if col2 in map:
            map[col2] = map[col2] + 1
    problem_2 = 0
    for key, value in map.items():
        problem_2 += key * value

    print(f"Problem 2 answer is {problem_2}")
