# Scouting App

Back in the day, I was a member of one of my high school's FTC robotics teams.  During competitions, we would need to "scout" all of the other teams in order to build an alliance.  I observed that most teams did this with paper and things got messy pretty quickly.

## Key Components

This scouting app allows the user to create multiple sheets `CDSheet.h`.  Each sheet stores a list of "entries" where an entry `CDSheetEntry.h` is simply a question that you would ask another team, as well as the input component you wish to use.  For example, you can have an entry whose question is "How many blocks can this robot lift?" with the input component being a UIStepper.  Other options included UISliders, UISegmentControls, UITextFields, and UISwitches.  This structure gives the user (or the team) the chance to fully customize a scouting sheet with the data collection settings that best suits them.

The sheet instance stores a list of teams `CDTeam.h` that have been scouted already.  You can add new teams in the app.  The answers to the sheet's questions will all be stored as part of that team's data.

This structure allows for custom scouting sheets which will store the questions and each team's answers in one place.

## Additional Features

1) You can customize the app to fit the theme of your team.  In the case of FTC Robotics, teams have a theme color.  Within Settings, you can set the accent color (navigation bars and tints) to match the color that represents your team.

2) You can "Favorite" teams that have outstanding capabilities in order to find them more easily later on.

3) You can perform an "Advanced Search" by setting parameters to narrow down the list of teams.  You can specify ranges that answers must fall within and if they do, those teams will be shown in a list.  This helps teams find worthy alliance partners by giving them the ability to quickly narrow down the list of teams based on criteria they are looking for.

## Reflections

This application works very well as a standalone tool.  In the future, I'd be interested in getting a backend in place to "scout" as a team and have all of the data in one place.  It's customizable, fast, and convenient and accomplishes the task that we wanted to simplify.


