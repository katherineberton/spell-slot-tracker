from pprint import pprint
import csv

slot_rules = {}


#standard classes, no warlock
class_markers = [('wizard_slot_table.csv', 'wizard'),
                 ('bard_slot_table.csv', 'bard'),
                 ('cleric_slot_table.csv', 'cleric'),
                 ('druid_slot_table.csv', 'druid'),
                 ('multiclass_slot_table.csv', 'multiclass'),
                 ('paladin_slot_table.csv', 'paladin'),
                 ('ranger_slot_table.csv', 'ranger'),
                 ('sorcerer_slot_table.csv', 'sorcerer')]


#set up a dict and add it to slot_rules with class slug as key and details as values
def make_dict(tup):

    class_dict = {}

    #open the file
    with open(f'./data/{tup[0]}') as slot_table:

        #translate each row in the file to a list with separation ','
        file = csv.reader(slot_table, delimiter=',')

        #for each row in the file
        for row in file:
            
            #the first column in the csv is the character level
            char_level = row[0]

            #declare empty dict for the stats at each character level
            class_dict[char_level] = {}

            #insert key value pair under this level for cantrips known, the number in 2nd column
            class_dict[char_level]['cantrips_known'] = int(row[1])

            #for the rest of the rows (slot levesl 1 through 9)
            for i in range(1,10):

                #create another key value pair with name max_slots_(level), and the value at the appropriate column
                class_dict[char_level][f'max_slots_{i}'] = int(row[i + 1])

    #put the whole dict as a value into the slot_rules dict with key equal to the class's slug
    slot_rules[tup[1]] = class_dict


#call on all standard classes
for toop in class_markers:
    make_dict(toop)



#warlock setup
warlock_dict = {}

with open('./data/warlock_slot_table.csv') as warlock_table:
    reading = csv.reader(warlock_table, delimiter=',')

    for row in reading:
        char_level = row[0]
        warlock_dict[char_level] = {}
        warlock_dict[char_level]['cantrips_known'] = int(row[1])
        warlock_dict[char_level]['slots'] = int(row[2])
        warlock_dict[char_level]['max_level'] = int(row[3])


#add warlock details to slot_rules
slot_rules['warlock'] = warlock_dict

