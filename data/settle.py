import csv
member = []
with open('BoardGame.csv', newline='') as m:
    spamreader = csv.reader(m)
    for row in spamreader:
        member.append([row[0], row[1]])

fix = [] 
with open('GameSession.csv', newline='') as em:
    spamreader = csv.reader(em)
    for row in spamreader:
        fix.append(row)
print(fix)
for i in fix:
    for j in member:
        if i[1] == j[1]:
            print(j)
            i[1] = j[0]

with open('GameSession.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(fix)