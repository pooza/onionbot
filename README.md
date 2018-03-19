# onionbot

[Chinachu](https://github.com/Chinachu/Chinachu)のイベントを、Slackに通知。  
現状は録画の開始と終了にのみ対応。

## ■動作要件

- 既にChinachu一式が構築済み。
- SlackのWebフックを作成済み。

## ■設置の手順

### リポジトリをクローン

```
git clone git@github.com:pooza/onionbot.git
```

クローンを行うとローカルにリポジトリが作成されるが、このディレクトリの名前は
変更しないことを推奨。（syslogのプログラム名や、設定ファイルのパス等に影響）

### 依存するgemのインストール

```
cd onionbot
bundle install
```

### local.yamlを編集

```
vi config/local.yaml
```

以下、設定例。

```
chinachu:
  url: http://localhost:20772/ #ChinachuのURL
slack:
  hook:
    url: https://hooks.slack.com/services/xxxxx #Slack WebフックのURL
```

### syslog設定

onionbotというプログラム名で、syslogに出力している。  
必要に応じて、適宜設定。以下、rsyslogでの設定例。

```
:programname, isequal, "onionbot" -/var/log/onionbot.log
```

## ■操作

loader.rbを実行する。root権限不要。  
通常はcronで5分毎等で起動すればよいと思う。

## ■設定ファイルの検索順

local.yamlは、上記設置例ではconfigディレクトリ内に置いているが、
実際には以下の順に検索している。（ROOT_DIRは設置先）

- /usr/local/etc/onionbot/local.yaml
- /usr/local/etc/onionbot/local.yml
- /etc/onionbot/local.yaml
- /etc/onionbot/local.yml
- __ROOT_DIR__/config/local.yaml
- __ROOT_DIR__/config/local.yml

ファイルが発見できた時点で、以降の検索をやめる。
