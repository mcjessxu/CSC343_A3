import csv
member = []
with open('Member.csv', newline='') as m:
    spamreader = csv.reader(m)
    for row in spamreader:
        member.append([row[0], row[2]])

fix = [] 
with open('CommitteeFellow.csv', newline='') as em:
    spamreader = csv.reader(em)
    for row in spamreader:
        fix.append(row)

for i in fix:
    for j in member:
        if i[3] == j[1]:
            print(j)
            i[3] = j[0]

with open('GameSession.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(fix)