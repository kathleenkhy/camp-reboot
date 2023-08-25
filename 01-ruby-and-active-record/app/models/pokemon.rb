require 'rest-client'
require 'json'

class Pokemon < ActiveRecord::Base
  # add your associations and methods here
  belongs_to :player

  def attack
    min_damage = damage - 10
    max_damage = damage + 10

    rand(min_damage..max_damage)
  end

  def take_damage(other_damage)
    defence_protection = rand(0..defence)
    defended_damage = other_damage - defence_protection
    if health >= defended_damage
      self.health -= defended_damage
    else
      self.health = 0
    end
  end

  def miss?
    random_number = rand
    probability = speed / 200.0
    random_number < probability

    # rand(200) < speed
  end

  def ko?
    health <= 0
  end

  def self.locate_stat(stat_hash, key)
    stat = stat_hash.find { |hash| hash['stat']['name'] == key }
    stat['base_stat']
  end

  def self.details(name)
    url = "https://pokeapi.co/api/v2/pokemon/#{name}/"
    response = JSON.parse(RestClient.get(url))
    stats = response['stats']

    {
      name: name,
      health: locate_stat(stats, 'hp'),
      damage: locate_stat(stats, 'attack'),
      defence: locate_stat(stats, 'defense'),
      speed: locate_stat(stats, 'speed'),
      image: response['sprites']['front_default']
    }
  end
end
