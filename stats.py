import mysql.connector
from tkinter import *
from tkinter import ttk
from prettytable import PrettyTable


# Connect to the MySQL database
cnx = mysql.connector.connect(user='root', password='airpods4sale', database='NBA')
cursor = cnx.cursor()

#function to display all the teams in the listbox
def display_teams():
    teams_query = "SELECT T_NAME FROM TEAM"
    cursor.execute(teams_query)
    teams = [team[0] for team in cursor.fetchall()]
    for team in teams:
        teams_listbox.insert(END, team)

# Function to fetch and display player names in the Listbox
def display_names():
    query = "SELECT P_NAME FROM PLAYER"
    cursor.execute(query)
    names = [name[0] for name in cursor.fetchall()]  # Fetch all names from the cursor
    for name in names:
        names_listbox.insert(END, name)  # Insert names into the Listbox widget

# Function to fetch and display stats of the selected player
def display_stats(event):
    # Get the selected player's name
    selected_player = names_listbox.get(names_listbox.curselection())
    
    # Query to fetch stats for the selected player
    stats_query = "SELECT * FROM PLAYER WHERE P_NAME = %s"
    cursor.execute(stats_query, (selected_player,))
    stats = cursor.fetchall()
    
    # Clear the stats display area
    stats_text.delete('1.0', END)
    
    # Display the stats in the text area
    stats_text.insert(END, f"Stats for {selected_player}:\n\n")
    for P_NUMBER, P_NAME, P_POSITION, P_PTS, P_REB, P_AST, P_FG, P_TEAM_ABBR in stats:
        stats_text.insert(END, f"Number: {P_NUMBER}\n")
        stats_text.insert(END, f"Name: {P_NAME}\n")
        stats_text.insert(END, f"Position: {P_POSITION}\n")
        stats_text.insert(END, f"Points: {P_PTS}\n")
        stats_text.insert(END, f"Rebounds: {P_REB}\n")
        stats_text.insert(END, f"Assists: {P_AST}\n")
        stats_text.insert(END, f"Field Goal %: {P_FG}%\n")
        stats_text.insert(END, f"Team: {P_TEAM_ABBR}\n")
        stats_text.insert(END, "-" * 30 + "\n") 

#Display the stats of the selected team
def display_team_stats(event):
    # Get the selected team's name
    selected_team = teams_listbox.get(teams_listbox.curselection())
    
    # Query to fetch stats for the selected team
    stats_query = "select T_NAME, T_SEED, T_WINS, T_LOSSES, (T_WINS / (T_WINS + T_LOSSES)) as WIN_PERCENTAGE from TEAM where T_NAME = %s"
    cursor.execute(stats_query, (selected_team,))
    stats = cursor.fetchall()

    #Query to fetch the players on the selected team
    players_query = "select P_NUMBER, P_NAME, P_POSITION, P_PTS, P_AST, P_REB, P_FG, T_NAME FROM PLAYER JOIN TEAM ON P_TEAM_ABBR = T_ABBREVIATION WHERE T_NAME = %s"
    cursor.execute(players_query, (selected_team,))
    
    # Clear the stats display area
    stats_text.delete('1.0', END)
    
    # Display the stats in the text area
    stats_text.insert(END, f"Stats for {selected_team}:\n\n")
    for T_NAME, T_SEED, T_WINS, T_LOSSES, WIN_PERCENTAGE  in stats:
        stats_text.insert(END, f"Name: {T_NAME}\n")
        stats_text.insert(END, f"Seed: {T_SEED}\n")
        stats_text.insert(END, f"Wins: {T_WINS}\n")
        stats_text.insert(END, f"Losses: {T_LOSSES}\n")
        stats_text.insert(END, f"Winning Percentage: {WIN_PERCENTAGE}\n")
        stats_text.insert(END, "-" * 30 + "\n")
    # Display the players in the text area
    x = PrettyTable()
    x.field_names = ["Number", "Name", "Position", "Points", "Assists", "Rebounds", "Field Goal %"]
    for P_NUMBER, P_NAME, P_POSITION, P_PTS, P_AST, P_REB, P_FG, T_NAME in cursor.fetchall():
        x.add_row([P_NUMBER, P_NAME, P_POSITION, P_PTS, P_AST, P_REB, P_FG])
    stats_text.insert(END, x)
    stats_text.insert(END, "-" * 10 + "\n")


# Function to search players by name
def search_players():
    # Get the search term
    search_term = search_entry.get().strip().lower()
    
    # Query to search players by name
    search_query = "SELECT P_NAME FROM PLAYER WHERE LOWER(P_NAME) LIKE %s"
    cursor.execute(search_query, (f"%{search_term}%",))
    results = cursor.fetchall()
    
    # Clear the Listbox
    names_listbox.delete(0, END)
    
    # Populate the Listbox with search results
    for (P_NAME,) in results:
        names_listbox.insert(END, P_NAME)

# Function to search teams by name
def search_teams():
    # Get the search term
    search_term = search_entry.get().strip().lower()
    
    # Query to search teams by name
    search_query = "SELECT T_NAME FROM TEAM WHERE LOWER(T_NAME) LIKE %s"
    cursor.execute(search_query, (f"%{search_term}%",))
    results = cursor.fetchall()
    
    # Clear the Listbox
    teams_listbox.delete(0, END)
    
    # Populate the Listbox with search results
    for (T_NAME,) in results:
        teams_listbox.insert(END, T_NAME)


# Create the main GUI window
root = Tk()
root.title("BoardMan Gets Paid")

# Create and configure the main frame
frm = ttk.Frame(root, padding=5)
frm.grid()

# Add a search bar
ttk.Label(frm, text="Search").grid(column=0, row=0, padx=0, pady=0, sticky='w')
search_entry = ttk.Entry(frm, width=18)
search_entry.grid(column=0, row=0, padx=5, pady=5, sticky='e')
#search for player
search_player_button = ttk.Button(frm, text="Search Player", command=search_players)
search_player_button.grid(column=1, row=0, padx=5, pady=5, sticky='w')
#search for team
search_team_button = ttk.Button(frm, text="Search Team", command=search_teams)
search_team_button.grid(column=1, row=0, padx=5, pady=5, sticky='e')

# Add a label for the Listbox
ttk.Label(frm, text="NBA Players:").grid(column=0, row=1, padx=5, pady=5)

# Add a Listbox widget to display player names
names_listbox = Listbox(frm, height=15, width=30)
names_listbox.grid(column=0, row=1, padx=5, pady=5)

# add a listbox for the teams
ttk.Label(frm, text="NBA Teams:").grid(column=2, row=0, padx=5, pady=5, sticky='n')
teams_listbox = Listbox(frm, height=15, width=30)
teams_listbox.grid(column=2, row=1, padx=5, pady=5, sticky='s')

# Bind the Listbox click event to the display_stats function
names_listbox.bind('<<ListboxSelect>>', display_stats)

# Bind the Listbox click event to the display_team_stats function
teams_listbox.bind('<<ListboxSelect>>', display_team_stats)

# Add a label for the stats display area
ttk.Label(frm, text="Stats:").grid(column=1, row=1, padx=3, pady=3, sticky='n')

# Add a Text widget to display the stats
stats_text = Text(frm, height=20, width=95, wrap=WORD)
stats_text.grid(column=1, row=1, padx=3, pady=3)

# Add a button to quit the application
ttk.Button(frm, text="Quit", command=root.destroy).grid(column=0, row=3, padx=5, pady=5)

# Call the function to populate the Listbox with player names
display_names()
#call the function to populate the listbox with team names
display_teams()


# Run the GUI event loop
root.mainloop()

# Close the database connection
cursor.close()
cnx.close()