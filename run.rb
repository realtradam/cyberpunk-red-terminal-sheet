require 'curses'
require 'pp'
include Curses
selector = 7
$defaultStat = 6

$defaultSkill = 0
$defaultSkillMin = 2

class Character

  @@stats = [["Int " , $defaultStat],
             ["Ref " , $defaultStat],
             ["Dex " , $defaultStat],
             ["Tech" , $defaultStat],
             ["Cool" , $defaultStat],
             ["Will" , $defaultStat],
             ["Luck" , $defaultStat],
             ["Move" , $defaultStat],
             ["Body" , $defaultStat],
             ["Emp " , $defaultStat]
  ]
  @@skills = [["Awareness Skills",[
    ["Concentration", "WILL", 2],
    ["Conceal/Reveal Object", "INT ", 0],
    ["Lib Reading", "INT ", 0],
    ["Perception", "INT ", 2],
    ["Tracking", "INT ",  0]]],
  ["Body Skills",[
    ["Athletics", "DEX ", 2],
    ["Contortionist", "DEX ", 0],
    ["Dance", "DEX ", 0],
    ["Endurance", "INT ", 0],
    ["Resist Torture/Drugs", "WILL", 0],
    ["Stealth", "DEX ",  2]]],
    ["Control Skills",[
      ["Drive Land Vehicle", "REF ", 0],
      ["Pilot Air Vehicle (x2)", "REF ", 2, 0],
      ["Pilot Sea Vehicle", "REF ", 0],
      ["Riding", "REF ",  0]]],
    ["Education Skills",[
      ["Accounting", "INT ", 0],
      ["Animal Handling", "INT ", 0],
      ["Bureaucracy", "INT ", 0],
      ["Business", "INT ", 0],
      ["Composition", "INT ", 0],
      ["Criminology", "INT ", 0],
      ["Cryptography", "INT ", 0],
      ["Deduction", "INT ", 0],
      ["Education", "INT ", 2],
      ["Gamble", "INT ", 0],
      ["Language (Cultural Origin)", "INT ", 4],
      ["Language (Streetslang)", "INT ", 2],
      ["Library Search", "INT ", 0],
      ["Local Expert (Your Home)", "INT ", 2],
      ["Science", "INT ", 0],
      ["Tactics", "INT ", 0],
      ["Wilderness Survival", "INT ",  0]]],
      ["Fighting",[
        ["Brawling", "DEX ", 2],
        ["Evasion", "DEX ", 2],
        ["Martial Arts (x2)", "INT ", 2, 0],
        ["Melee Weapon", "DEX ",  0]]],
      ["Performance",[
        ["Acting", "COOL", 0],
        ["Play Instrument", "TECH",  0]]],
        ["Ranged Weapon",[
          ["Archery", "REF ", 0],
          ["Autofire (x2)", "REF ", 2, 0],
          ["Handgun", "REF ", 0],
          ["Heavy Weapons (x2)", "REF ", 2, 0],
          ["Shoulder Arms", "REF ",  0]]],
        ["Social Skills",[
          ["Bribery", "COOL", 0],
          ["Conversation", "EMP ", 2],
          ["Human Perception", "EMP ", 2],
          ["Interrogation", "COOL", 0],
          ["Persuasion", "COOL", 2],
          ["Personal Grooming", "COOL", 0],
          ["Streetwise", "COOL", 0],
          ["Trading", "COOL", 0],
          ["Wardrobe & Style", "COOL",  0]]],
          ["Technique Skills",[
            ["Air Vehicle Tech", "TECH", 0],
            ["Basic Tech", "TECH", 0],
            ["Cybertech", "TECH", 0],
            ["Demolitions (x2)", "TECH", 2, 0],
            ["Electronics/Security Tech (x2)", "TECH", 0],
            ["First Aid", "TECH", 2],
            ["Forgery", "TECH", 0],
            ["Land Vehicle Tech", "TECH", 0],
            ["Paint/Draw/Sculpt", "TECH", 0],
            ["Paramedic (x2)", "TECH", 2, 0],
            ["Photography/Film", "TECH", 0],
            ["Pick Lock", "TECH", 0],
            ["Pick Pocket", "TECH", 0],
            ["Sea Vehicle Tech", "TECH", 0],
            ["Weaponstech", "TECH",  0]]]
  ]
  @@minimumSkill = ["Athletics", "Brawling", "Concentration", "Conversation", "Education", "Evasion", "First Aid", "Human Perception", "Language (Streetslang)", "Local Expert (Your Home)", "Perception", "Persuasion", "Stealth"]

  @@freeSkill = { "Language (Cultural Origin)" => 4 }

  def totalStats
    sum = 0
    @@stats.each{
      |stat|
      sum += stat[1]
    }
    sum
  end
  def totalSkills
    sum = 0
    @@skills.each do |group|
      group[1].each do |skill|
        unless skill.length == 4
          if @@freeSkill.has_key?(skill[0])
            if @@freeSkill[skill[0]] <= skill.last
              sum += (skill.last - @@freeSkill[skill[0]])
            end
          else
            sum += skill.last
          end
        else
          sum += skill.last * skill[2]
        end
      end
    end
    sum
  end
  def statsVar
    @@stats
  end
  def skills
    @@skills
  end
  def minimumSkill
    @@minimumSkill
  end
end
class Interface
  def pickStats(yourStats)
    key = nil
    selector = 7
    Curses.clear
    while key != 'q'
      Curses.setpos(0,20)
      Curses.addstr("Press q to go back, and w,a,s,d keys to control")
      Curses.setpos(3,5)
      spent = yourStats.totalStats
      if spent > 62
        Curses.attron(color_pair(COLOR_RED)|A_NORMAL){
          Curses.addstr("Points Spent: " + yourStats.totalStats.to_s + "/62")
        }
      elsif spent == 62
        Curses.attron(color_pair(COLOR_GREEN)|A_NORMAL){
          Curses.addstr("Points Spent: " + yourStats.totalStats.to_s+ "/62")
        }
      else
        Curses.attron(color_pair(COLOR_YELLOW)|A_NORMAL){
          Curses.addstr("Points Spent: " + yourStats.totalStats.to_s+ "/62")
        }
      end
      yourStats.statsVar.each_with_index { |pair,index|
        Curses.setpos(index + 5, 3)
        if pair[1] <= 8 && pair[1] >= 2
          if pair[1] > 7
            Curses.attron(color_pair(COLOR_CYAN)|A_NORMAL){
              unless index == selector
                Curses.addstr(pair[0] + " " + pair[1].to_s)
              else
                Curses.setpos(index + 5, 0)
                Curses.addstr(" > " + pair[0] + " " + pair[1].to_s)
              end
            }
          elsif pair[1] > 5
            Curses.attron(color_pair(COLOR_GREEN)|A_NORMAL){
              unless index == selector
                Curses.addstr(pair[0] + " " + pair[1].to_s)
              else
                Curses.setpos(index + 5, 0)
                Curses.addstr(" > " + pair[0] + " " + pair[1].to_s)
              end
            }
          elsif pair[1] > 3
            Curses.attron(color_pair(COLOR_YELLOW)|A_NORMAL){
              unless index == selector
                Curses.addstr(pair[0] + " " + pair[1].to_s)
              else
                Curses.setpos(index + 5, 0)
                Curses.addstr(" > " + pair[0] + " " + pair[1].to_s)
              end
            }
          else
            Curses.attron(color_pair(COLOR_MAGENTA)|A_NORMAL){
              unless index == selector
                Curses.addstr(pair[0] + " " + pair[1].to_s)
              else
                Curses.setpos(index + 5, 0)
                Curses.addstr(" > " + pair[0] + " " + pair[1].to_s)
              end
            }
          end
        else
          Curses.attron(color_pair(COLOR_RED)|A_NORMAL){
            unless index == selector
              Curses.addstr(pair[0] + " " + pair[1].to_s)
            else
                Curses.setpos(index + 5, 0)
              Curses.addstr(" > " + pair[0] + " " + pair[1].to_s)
            end
          }
        end
      }
      Curses.refresh
      key = Curses.getch
      Curses.clear
      if key == 'w' && selector > 0
        selector -= 1
      elsif key == 's' && selector < (yourStats.statsVar.length - 1)
        selector += 1
      end
      if key == 'a' 
        yourStats.statsVar[selector][1] -= 1
      elsif key == 'd'
        yourStats.statsVar[selector][1] += 1
      end

    end
  end
  def pickSkills(character)
    key = nil
    selector = [0,0]
    Curses.clear
    while key != 'q'
      Curses.setpos(0,20)
      Curses.addstr("Press q to go back, and w,a,s,d keys to control, z to sort")
      Curses.setpos(3,5)
      spent = character.totalSkills
      if spent > 86
        Curses.attron(color_pair(COLOR_RED)|A_NORMAL){
          Curses.addstr("Points Spent: " + spent.to_s + "/86")
        }
      elsif spent == 86
        Curses.attron(color_pair(COLOR_GREEN)|A_NORMAL){
          Curses.addstr("Points Spent: " + spent.to_s + "/86")
        }
      else
        Curses.attron(color_pair(COLOR_YELLOW)|A_NORMAL){
          Curses.addstr("Points Spent: " + spent.to_s + "/86")
        }
      end
      itemItr = 0 # which item we are on, in the iteration
      # we add the "group" index to this number
      lastIndex = 0 # checks if you want to do a new column
      oldOffset = 0 # using this lets you split it into columns
      col = 0
      character.skills.each_with_index do |group,index|
        unless lastIndex == (index / 3) # change number to be how many columns you want
          itemItr = 0
          lastIndex = (index / 3) # change number to how many columns you want
          oldOffset += index - oldOffset
        end
        Curses.setpos(itemItr + ((index - oldOffset) * 2) + 5, (index / 3) * 45)
        Curses.addstr(" " + group[0])
        group[1].each_with_index do |skill,skillIndex|
          itemItr += 1
          Curses.setpos(itemItr + ((index  - oldOffset) * 2)   + 5, (index / 3) * 45)
          Curses.addstr("   " + skill[1] + " ╎")

          if (skill.last > 6 || skill.last < 0) || (character.minimumSkill.include?(skill[0]) && skill.last < 2)
            Curses.attron(color_pair(COLOR_RED)|A_NORMAL){
              Curses.addstr(skill[0]) 
              Curses.setpos(itemItr + ((index  - oldOffset) * 2)   + 5, (((index) / 3) * 45) + 42 - skill.last.to_s.length)
              Curses.addstr(skill.last.to_s)
            }
          elsif skill.last > 5
            Curses.attron(color_pair(COLOR_CYAN)|A_NORMAL){
              Curses.addstr(skill[0]) 
              Curses.setpos(itemItr + ((index  - oldOffset) * 2)   + 5, (((index) / 3) * 45) + 42 - skill.last.to_s.length)
              Curses.addstr(skill.last.to_s)
            }
          elsif skill.last > 3
            Curses.attron(color_pair(COLOR_GREEN)|A_NORMAL){
              Curses.addstr(skill[0]) 
              Curses.setpos(itemItr + ((index  - oldOffset) * 2)   + 5, (((index) / 3) * 45) + 42 - skill.last.to_s.length)
              Curses.addstr(skill.last.to_s)
            }
          elsif skill.last > 1
            Curses.attron(color_pair(COLOR_YELLOW)|A_NORMAL){
              Curses.addstr(skill[0]) 
              Curses.setpos(itemItr + ((index  - oldOffset) * 2)   + 5, (((index) / 3) * 45) + 42 - skill.last.to_s.length)
              Curses.addstr(skill.last.to_s)
            }
          else
            Curses.attron(color_pair(COLOR_MAGENTA)|A_NORMAL){
              Curses.addstr(skill[0]) 
              Curses.setpos(itemItr + ((index  - oldOffset) * 2)   + 5, (((index) / 3) * 45) + 42 - skill.last.to_s.length)
              Curses.addstr(skill.last.to_s)
            }
          end



          if group[1].first == skill
            Curses.addstr(" ╮")
          elsif group[1].last == skill
            Curses.addstr(" ╯")
          else
            Curses.addstr(" │")
          end
              if selector[0] == index && selector[1] == skillIndex
                Curses.setpos(itemItr + ((index  - oldOffset) * 2)   + 5, (index / 3) * 45)
                Curses.addstr(" > ")
              end
        end
      end


      Curses.refresh
      key = Curses.getch
      Curses.clear
      if key == 's'
        selector[1] += 1
        if selector[1] == character.skills[selector[0]][1].length
          selector[1] = 0
          selector[0] += 1
          if selector[0] == character.skills.length
            selector[0] = 0
          end
        end
      elsif key == 'w'
        selector[1] -= 1
        if selector[1] < 0
          selector[0] -= 1
          selector[1] = character.skills[selector[0]][1].length - 1
          if selector[0] < 0
            selector[0] = character.skills.length - 1
          end
        end
      elsif key == 'z'
        character.skills.each do |group|
          group[1].sort_by!(&:last).reverse!
        end
      end
      if key == 'a' 
        character.skills[selector[0]][1][selector[1]][character.skills[selector[0]][1][selector[1]].length - 1] -= 1
      elsif key == 'd'
        character.skills[selector[0]][1][selector[1]][character.skills[selector[0]][1][selector[1]].length - 1] += 1
      end
    end
  end
  def menu(character)
    selector = 0
    key = nil
    while key != "q"
      Curses.clear
      Curses.setpos(0,20)
      Curses.addstr("Press q to exit, w and s to select, and a or d to confirm")
      Curses.setpos(15,15)
      Curses.addstr("Stats")
      Curses.setpos(16,15)
      Curses.addstr("Skills")
      if (key == 'w') || (key == 's')
        selector = (selector + 1) % 2
      end
      if selector == 0
        if (key == 'a') || (key == 'd')
          self.pickStats(character)
        end
        Curses.setpos(15,13)
        Curses.addstr("> ")
      else
        if (key == 'a') || (key == 'd')
          self.pickSkills(character)
        end
        Curses.setpos(16,13)
        Curses.addstr("> ")
      end
      unless (key == 'a') || (key == 'd')
        key = Curses.getch
      else
        key = nil
      end
    end
  end
end

me = Character.new
interface = Interface.new

Curses.init_screen
Curses.start_color
Curses.noecho
Curses.curs_set(0)

Curses.init_pair(COLOR_RED,COLOR_BLACK,COLOR_RED) #Invalid Value

Curses.init_pair(COLOR_CYAN,COLOR_CYAN,COLOR_BLACK) #Amazing Value
Curses.init_pair(COLOR_GREEN,COLOR_GREEN,COLOR_BLACK) #High Value
Curses.init_pair(COLOR_YELLOW,COLOR_YELLOW,COLOR_BLACK) #Low Value
Curses.init_pair(COLOR_MAGENTA,COLOR_RED,COLOR_BLACK) #Bad Value




interface.menu(me)


#interface.pickStats(me)
