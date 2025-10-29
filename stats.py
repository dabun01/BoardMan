password = "airpods4sale"
import os
import mysql.connector
import tkinter as tk
from tkinter import ttk
from prettytable import PrettyTable

# Connect to the MySQL database
cnx = mysql.connector.connect(user='root', password = password, database='NBA')
cursor = cnx.cursor()

#function to display all the teams in the listbox
def display_teams():
    teams_query = "SELECT T_NAME FROM TEAM"
    cursor.execute(teams_query)
    rows = cursor.fetchall()
    # Support both tuple rows and dict-like rows returned by some cursor configurations
    teams = [row['T_NAME'] if isinstance(row, dict) else row[0] for row in rows]
    for team in teams:
        teams_listbox.insert(tk.END, team) # type: ignore

# Function to fetch and display player names in the Listbox
def display_names():
    query = "SELECT P_NAME FROM PLAYER ORDER BY P_NAME"
    cursor.execute(query)
    names = [name[0] for name in cursor.fetchall()]  # type: ignore # Fetch all names from the cursor
    for name in names:
        names_listbox.insert(tk.END, name)  # type: ignore # Insert names into the Listbox widget

# Function to fetch and display stats of the selected player
def display_stats(event):
    # Check if something is selected
    selection = names_listbox.curselection()
    if not selection:
        return  # Exit if nothing is selected
    
    # Get the selected player's name
    selected_player = names_listbox.get(names_listbox.curselection())
    
    # Query to fetch stats for the selected player
    stats_query = "SELECT * FROM PLAYER WHERE P_NAME = %s"
    cursor.execute(stats_query, (selected_player,))
    stats = cursor.fetchall()
    
    # Clear the stats display area
    stats_text.delete('1.0', tk.END)
    
    # Display the stats in the text area
    stats_text.insert(tk.END, f"Stats for {selected_player}:\n\n")
    for P_NUMBER, P_NAME, P_POSITION, P_PTS, P_REB, P_AST, P_FG, P_TEAM_ABBR in stats:
        stats_text.insert(tk.END, f"Number: {P_NUMBER}\n")
        stats_text.insert(tk.END, f"Name: {P_NAME}\n")
        stats_text.insert(tk.END, f"Position: {P_POSITION}\n")
        stats_text.insert(tk.END, f"Points: {P_PTS}\n")
        stats_text.insert(tk.END, f"Rebounds: {P_REB}\n")
        stats_text.insert(tk.END, f"Assists: {P_AST}\n")
        stats_text.insert(tk.END, f"Field Goal %: {P_FG}%\n")
        stats_text.insert(tk.END, f"Team: {P_TEAM_ABBR}\n")
        stats_text.insert(tk.END, "-" * 30 + "\n") 

#Display the stats of the selected team
def display_team_stats(event):
    #Check if something is selected
    selection = teams_listbox.curselection()
    if not selection:
        return #Exit if nothing is selected
    
    # Get the selected team's name
    selected_team = teams_listbox.get(teams_listbox.curselection())
    
    # Query to fetch stats for the selected team
    stats_query = "select T_NAME, T_SEED, T_WINS, T_LOSSES, T_CHAMPIONSHIPS, (T_WINS / (T_WINS + T_LOSSES)) as WIN_PERCENTAGE from TEAM where T_NAME = %s"
    cursor.execute(stats_query, (selected_team,))
    stats = cursor.fetchall()

    #Query to fetch the players on the selected team
    players_query = "select P_NUMBER, P_NAME, P_POSITION, P_PTS, P_AST, P_REB, P_FG, T_NAME FROM PLAYER JOIN TEAM ON P_TEAM_ABBR = T_ABBREVIATION WHERE T_NAME = %s"
    cursor.execute(players_query, (selected_team,))
    
    # Clear the stats display area
    stats_text.delete('1.0', tk.END)
    
    # Display the stats in the text area
    stats_text.insert(tk.END, f"Stats for {selected_team}:\n\n")
    for T_NAME, T_SEED, T_WINS, T_LOSSES, T_CHAMPIONSHIPS, WIN_PERCENTAGE in stats:
        stats_text.insert(tk.END, f"Name: {T_NAME}\n")
        stats_text.insert(tk.END, f"Seed: {T_SEED}\n")
        stats_text.insert(tk.END, f"Wins: {T_WINS}\n")
        stats_text.insert(tk.END, f"Losses: {T_LOSSES}\n")
        stats_text.insert(tk.END, f"Championships: {T_CHAMPIONSHIPS}\n")
        stats_text.insert(tk.END, f"Winning Percentage: {WIN_PERCENTAGE}\n")
        stats_text.insert(tk.END, "-" * 30 + "\n")
    # Display the players in the text area
    x = PrettyTable()
    x.field_names = ["Number", "Name", "Position", "Points", "Assists", "Rebounds", "Field Goal %"]
    for P_NUMBER, P_NAME, P_POSITION, P_PTS, P_AST, P_REB, P_FG, T_NAME in cursor.fetchall():
        x.add_row([P_NUMBER, P_NAME, P_POSITION, P_PTS, P_AST, P_REB, P_FG])
    stats_text.insert(tk.END, x) # type: ignore

# Function to search players by name
def search_players():
    # Get the search term
    search_term = search_entry.get().strip().lower()

    if search_term == "":
        stats_text.delete('1.0', tk.END)  # Clear the stats display area before showing the error
        stats_text.insert(tk.END, "Error: Please enter a valid player name.")
        display_names() # Re-display all names
    else:
        try:
            # Query to search players by name
            search_query = "SELECT P_NAME FROM PLAYER WHERE LOWER(P_NAME) LIKE %s"
            cursor.execute(search_query, (f"%{search_term}%",))
            results = cursor.fetchall()
            
            # Clear the Listbox
            names_listbox.delete(0, tk.END)

            if results == []:
                clear_stats()  # Clear the stats display area before showing the error
                stats_text.insert(tk.END, "Error: No players found with that name. Click on Search Player to see all players.")
            else:
                # Populate the Listbox with search results
                for (P_NAME,) in results:
                    names_listbox.insert(tk.END, P_NAME) # type: ignore
        except Exception as e:
            #Handle potential database errors
            clear_stats()
            stats_text.insert(tk.END, f"Error fetching data: {e}")

# Function to search teams by name
def search_teams():
    # Get the search term
    search_term = search_entry.get().strip().lower()

    if search_term == "":
        stats_text.delete('1.0', tk.END)  # Clear the stats display area before showing the error
        stats_text.insert(tk.END, "Error: Please enter a valid team name.")
        display_teams() # Re-display all teams
    else:
        try:
            # Query to search teams by name
            search_query = "SELECT T_NAME FROM TEAM WHERE LOWER(T_NAME) LIKE %s"
            cursor.execute(search_query, (f"%{search_term}%",))
            results = cursor.fetchall()

            # Clear the Listbox
            teams_listbox.delete(0, tk.END)

            if results == []:
                clear_stats()  # Clear the stats display area before showing the error
                stats_text.insert(tk.END, "Error: No teams found with that name.")
            else:
                # Populate the Listbox with search results
                for (T_NAME,) in results:
                    teams_listbox.insert(tk.END, T_NAME) # type: ignore
        except Exception as e:
            #Handle potential database errors
            clear_stats()  # Clear the stats display area before showing the error
            stats_text.insert(tk.END, f"Error fetching data: {e}")

#Function where if in the search bar you type east or west it will display the teams in that conference in the right listbox
# And in the center textbox the standings of the teams in that conference 
def search_conference():
    # Get the search term
    search_term = search_entry.get().strip().lower()
    # Check if the search term is either 'east' or 'west'
    if search_term not in {"east", "west"}:
        clear_stats()  # Clear the stats display area before showing the error
        stats_text.insert(tk.END, "Error: Please enter either 'East' or 'West'.")
    else:
        try:
            # Query to search teams by conference name
            search_conf_query = "SELECT T_NAME FROM TEAM WHERE LOWER(C_ABBREVIATION) LIKE %s ORDER BY T_SEED"
            cursor.execute(search_conf_query, (f"%{search_term}%",))
            results = cursor.fetchall()

            # Clear the Listbox
            teams_listbox.delete(0, tk.END)

            # Populate the Listbox with search results
            for (T_NAME,) in results:
                teams_listbox.insert(tk.END, T_NAME) # type: ignore

            # Query to fetch stats for the selected team
            stats_query = "select T_NAME, T_SEED, T_WINS, T_LOSSES, (T_WINS / (T_WINS + T_LOSSES)) as WIN_PERCENTAGE from TEAM  where C_ABBREVIATION LIKE %s ORDER BY T_SEED"
            cursor.execute(stats_query, (search_term,))
            stats = cursor.fetchall()

            # Clear the stats display area
            clear_stats()
            # Display the conference standings in the text area
            x = PrettyTable()
            x.field_names = ["Team Name", "Seed", "Wins", "Losses", "Win%",]
            for T_NAME, T_SEED, T_WINS, T_LOSSES, WIN_PERCENTAGE in stats:
                x.add_row([T_NAME, T_SEED, T_WINS, T_LOSSES, WIN_PERCENTAGE])
            stats_text.insert(tk.END, x) # type: ignore
        except Exception as e:
            #Handle potential database errors
            clear_stats()  # Clear the stats display area before showing the error
            stats_text.insert(tk.END, f"Error fetching data: {e}")

# Function to search players by Point per game if the user types in MVP in the search bar it will display the top 5 players in the league
def search_mvp():
    search_query = "select P_NUMBER, P_NAME, P_PTS, P_REB, P_AST, P_FG, P_TEAM_ABBR from PLAYER WHERE P_PTS >= 30;"
    cursor.execute(search_query)
    results = cursor.fetchall()

    # Clear the stats display area
    stats_text.delete('1.0', tk.END)

    # Display the stats in the text area
    mvp = PrettyTable()
    mvp.field_names = ["Number", "Name", "Points", "Rebounds", "Assists", "Field Goal %", "Team"]
    for P_NUMBER, P_NAME, P_PTS, P_REB, P_AST, P_FG, P_TEAM_ABBR in results:
        mvp.add_row([P_NUMBER, P_NAME, P_PTS, P_REB, P_AST, P_FG, P_TEAM_ABBR])
    stats_text.insert(tk.END, mvp) # type: ignore
# Function to clear the stats display area
def clear_stats():
    stats_text.delete('1.0', tk.END)

# Create the main GUI window
root = tk.Tk()
root.title("BoardMan Gets Paid")

# Create and configure the main frame
frm = ttk.Frame(root, padding=5)
frm.grid()

# Add a search bar
ttk.Label(frm, text="Search").grid(column=0, row=0, padx=0, pady=0, sticky='w')
search_entry = ttk.Entry(frm, width=18)
search_entry.grid(column=0, row=0, padx=5, pady=5, sticky='e')

#search for player button
search_player_button = ttk.Button(frm, text="Search Player", command=search_players)
search_player_button.grid(column=1, row=0, padx=5, pady=5, sticky='w')

#search for team button
search_team_button = ttk.Button(frm, text="Search Team", command=search_teams)
search_team_button.grid(column=1, row=0, padx=5, pady=5, sticky='e')

#search for conference button
search_conference_button = ttk.Button(frm, text="Search Conference", command=search_conference)
search_conference_button.grid(column=1, row=0, padx=5, pady=5, sticky='n')

#mvp button
search_mvp_button = ttk.Button(frm, text="MVP", command=search_mvp)
search_mvp_button.grid(column=0, row=3, padx=5, pady=5, sticky='e')

# Bind the Search MVP button to the search_mvp function
search_mvp_button.config(command=search_mvp)

# Add a label for the Listbox
ttk.Label(frm, text="NBA Players:").grid(column=0, row=1, padx=5, pady=5)

# Add a Listbox widget to display player names
names_listbox = tk.Listbox(frm, height=20, width=30)
names_listbox.grid(column=0, row=1, padx=5, pady=5)

# Bind the Listbox click event to the display_stats function
names_listbox.bind('<<ListboxSelect>>', display_stats)

# add a listbox for the teams
ttk.Label(frm, text="NBA Teams:").grid(column=2, row=0, padx=5, pady=5)
teams_listbox = tk.Listbox(frm, height=20, width=30)
teams_listbox.grid(column=2, row=1, padx=5, pady=5)

# Bind the Listbox click event to the display_team_stats function
teams_listbox.bind('<<ListboxSelect>>', display_team_stats)

# Add a Text widget to display the stats
stats_text = tk.Text(frm, height=20, width=95, wrap=tk.WORD)
stats_text.grid(column=1, row=1, padx=3, pady=3)

# Add a button to quit the application
ttk.Button(frm, text="Quit", command=root.destroy).grid(column=0, row=3, padx=5, pady=5, sticky='w')

# Call the function to populate the Listbox with player names
display_names()
#call the function to populate the listbox with team names
display_teams()

# Run the GUI event loop
root.mainloop()

# Close the database connection
cursor.close()
cnx.close()