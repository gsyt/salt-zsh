{% from "zsh/map.jinja" import zsh with context %}

{% set package = {
  'name': zsh.package,
  'upgrade': salt['pillar.get']('zsh:package:upgrade', False),
} %}

{% set config = {
  'manage': salt['pillar.get']('zsh:config:manage', False),
  'ohmyzsh': {
    'manage': salt['pillar.get']('zsh:config:ohmyzsh:manage', True),
    'source': salt['pillar.get']('zsh:config:ohmyzsh:source', 'https://github.com/robbyrussell/oh-my-zsh.git'),
  },
  'users': salt['pillar.get']('zsh:config:users', []),
  'source': salt['pillar.get']('zsh:config:source', 'salt://zsh/conf/zshrc'),
} %}

zsh.installed:
  require:
    - sls: zsh.install
    - sls: zsh.configure

zsh.install:
  pkg.{{ 'latest' if package.upgrade else 'installed' }}:
    - name: {{ package.name }}

zsh.configure:
  require:
    - sls: zsh.install
{% if config.manage %}
  {% if config.users %}
    {% for user in config.users %}
      {% if salt['user.info'](user) %}
        {% if config.ohmyzsh.manage %}
    - sls: ohmyzsh-{{ user }}
        {% endif %}
    - sls: zshrc-{{ user }}
      {% endif %}
    {% endfor %}

    {% for user in config.users %}
      {% if salt['user.info'](user) %}
        {% set userhome = salt['user.info'](user).home %}
zshrc-{{ user }}:
  file.managed:
    - name: {{ userhome }}/.zshrc
    - source: {{ config.source }}
    - user: {{ user }}
  require:
    - sls: ohmyzsh-{{ user }}

        {% if config.ohmyzsh.manage %}
ohmyzsh-{{ user }}:
  git.latest:
    - name: {{ config.ohmyzsh.source }}
    - target: {{ userhome }}/.oh-my-zsh
    - user: {{ user }}
        {% endif %}
      {% endif %}
    {% endfor %}
  {% endif %}
{% endif %}
