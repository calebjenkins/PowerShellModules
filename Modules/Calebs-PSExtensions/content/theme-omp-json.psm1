function Write-SampleOmpTheme {
  param (
    [string]$Path
  )

  _checkParam $Path "Please provide a path to save the theme file"

  $data = @{
    "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
    "palette": {
      "c-badge-folder": "#FFD770",
      "c-badge-return-custom": "#E7B9FF",
      "c-badge-return-fail-term": "#FF8A80",
      "c-badge-return-success": "#B2FF59",
      "c-badge-text": "#212121",
      "c-badge-white": "#FAFAFA",
      "c-battery-100-less": "#CCFF90",
      "c-battery-15-less": "#FF8A80",
      "c-battery-30-less": "#FFD180",
      "c-battery-45-less": "#FFE57F",
      "c-battery-55-less": "#FFFF8D",
      "c-battery-70-less": "#F4FF81",
      "c-battery-90-less": "#B9F6CA",
      "c-battery-state-error": "#FF867F",
      "c-date-time-afternoon": "#FFC400",
      "c-date-time-evening": "#C0CFFF",
      "c-date-time-morning": "#FFFF8D",
      "c-date-time-night": "#83B9FF",
      "c-date-time-noon": "#FFF64F",
      "c-exec-fast": "#C6FF00",
      "c-exec-normal": "#FFFF00",
      "c-exec-slow": "#FFD180",
      "c-exec-slower": "#FF867F",
      "c-git-ahead": "#6EFFFF",
      "c-git-ahead-behind": "#C0CFFF",
      "c-git-behind": "#FFA06D",
      "c-git-normal": "#66FFA6",
      "c-git-staging": "#FFD740",
      "c-git-staging-working": "#FFB2FF",
      "c-git-upstream-gone": "#FF867F",
      "c-git-working": "#84FFFF",
      "c-project-crystal": "#FFFFFF",
      "c-project-flutter": "#6DC2FF",
      "c-project-generic-error": "#FF867F",
      "c-project-lua": "#BBC2FF",
      "c-project-node": "#9CFF57",
      "c-project-python": "#FFE873",
      "c-project-rust": "#FFAB40",
      "c-secondary-ellipsis": "#FFFF8D",
      "c-shell-state-root-active": "#9FFFE0",
      "c-shell-state-root-ssh-active": "#FFB2FF",
      "c-shell-state-ssh-active": "#BAFFFF",
      "c-wakatime-overtime": "#FF8A80",
      "c-wakatime-quota": "#FFD0B0",
      "c-wakatime-undertime": "#A7FFEB",
      "c-wakatime-warm-up": "#FFFFB3",
      "c-wakatime-working": "#FFD180"
    },
    "secondary_prompt": {
      "template": " ... ",
      "foreground": "p:c-secondary-ellipsis",
      "background": "transparent"
    },
    "transient_prompt": {
      "template": "{{ if eq \"False\" (title (default \"False\" .Env.DISABLE_SEGMENT_TRANSIENT)) }}<{{ if eq .Code 0 }}p:c-badge-return-success{{ else if or (eq .Code 1) (eq .Code 130) }}p:c-badge-return-fail-term{{ else }}p:c-badge-return-custom{{ end }}>\ue0b6</><p:c-badge-text,{{ if eq .Code 0 }}p:c-badge-return-success{{ else if or (eq .Code 1) (eq .Code 130) }}p:c-badge-return-fail-term{{ else }}p:c-badge-return-custom{{ end }}>💻 \ue0b1 {{ if .Segments.Executiontime.Ms }}{{ if eq \"False\" (title (default \"False\" .Env.DISABLE_SEGMENT_TRANSIENT_EXEC_TIME)) }} ➡️ {{ .Segments.Executiontime.FormattedMs }} {{ end }}{{ end }}<b>{{ if eq .Code 0 }} ✔️ OK{{ else if eq .Code 1 }}❌ FAIL{{ else if eq .Code 130 }}TERM{{ else }}Code{{ end }}</b></><{{ if eq .Code 0 }}p:c-badge-return-success{{ else if or (eq .Code 1) (eq .Code 130) }}p:c-badge-return-fail-term{{ else }}p:c-badge-return-custom{{ end }}>\ue0b4</> {{ end }} "
    },
    "console_title_template": "{{ if .Segments.Session.SSHSession }}SSH'd{{ if or .Root }} & {{ end }}{{ end }}{{ if .Root }}# (as {{ .UserName }}) | {{ end }}{{ if .WSL }}WSL | {{ end }}{{ .Folder }} ({{ .Shell }})",
    "blocks": [ {
      "type": "prompt",
      "alignment": "left",
      "segments": [ {
        "properties": {
          "cache_duration": "none",
          "windows": "\ue62a "
        },
        "leading_diamond": "\ue0b6",
        "template": "\uf108 {{ .HostName }} 🚀 {{ .UserName }} ",
        "foreground": "#ffffff",
        "powerline_symbol": "\ue0b0",
        "background": "#2e9599",
        "type": "session",
        "style": "diamond"
      }, {
        "properties": {
          "cache_duration": "none",
          "windows": "\ue62a "
        },
        "leading_diamond": "\ue0b4",
        "template": " {{ if .WSL }}WSL at {{ end }}{{.Icon}}",
        "foreground": "#fff",
        "powerline_symbol": "\ue0b0",
        "background": "#003543",
        "type": "os",
        "style": "powerline"
      }, {
        "properties": {
          "cache_duration": "none",
          "folder_separator_icon": "/",
          "style": "full"
        },
        "template": " \ue5ff {{ .Path }} ",
        "foreground": "#003544",
        "powerline_symbol": "\ue0b0",
        "background": "#0087D8",
        "type": "path",
        "style": "powerline"
      }, {
        "properties": {
          "cache_duration": "none",
          "fetch_stash_count": true,
          "fetch_status": true,
          "fetch_upstream_icon": true
        },
        "template": " {{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }} \ue621 \uf6fc {{ .StashCount }}{{ end }} ",
        "foreground": "#193549",
        "powerline_symbol": "\ue0b0",
        "background": "#08f32f",
        "type": "git",
        "style": "powerline",
        "background_templates": [
        "{{ if or (.Working.Changed) (.Staging.Changed) }}#ff9248{{ end }}",
        "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#f26d50{{ end }}",
        "{{ if gt .Ahead 0 }}#a108f3{{ end }}",
        "{{ if gt .Behind 0 }}#f19d00{{ end }}"
        ]
      }, {
        "properties": {
          "cache_duration": "none"
        },
        "template": " \ue77f {{ .Full }} ",
        "foreground": "#000000",
        "powerline_symbol": "\ue0b0",
        "background": "#00ffff",
        "type": "dotnet",
        "style": "accordion"
      }
      ],
      "newline": true
    }, {
      "type": "prompt",
      "alignment": "right",
      "overflow": "hide",
      "segments": [ {
        "properties": {
          "cache_duration": "none",
          "style": "austin",
          "threshold": 1
        },
        "leading_diamond": "\ue0b6",
        "trailing_diamond": "\ue0b4 ",
        "template": "{{ if eq \"False\" (title (default \"False\" .Env.DISABLE_SEGMENT_PRIMARY_EXEC_TIME)) }} ⌛ {{ .FormattedMs }}.{{ end }}",
        "foreground": "p:c-badge-text",
        "type": "executiontime",
        "style": "diamond",
        "background_templates": [
        "{{ if lt .Ms 60000 }}p:c-exec-fast{{ end }}",
        "{{ if lt .Ms 3600000 }}p:c-exec-normal{{ end }}",
        "{{ if lt .Ms 10800000 }}p:c-exec-slow{{ end }}",
        "{{ if ge .Ms 10800000 }}p:c-exec-slower{{ end }}"
        ]
      }, {
        "properties": {
          "cache_duration": "none",
          "time_format": "3:04pm 📅 Jan 02"
        },
        "leading_diamond": "\ue0b6",
        "trailing_diamond": "\ue0b4 ",
        "template": "{{ if eq \"False\" (title (default \"False\" .Env.DISABLE_SEGMENT_DTIME)) }} {{ .CurrentDate | date .Format }}{{ end }}",
        "foreground": "p:c-badge-text",
        "type": "time",
        "style": "diamond",
        "background": "#b4f308"
      }
      ]
    }, {
      "type": "prompt",
      "alignment": "left",
      "segments": [ {
        "properties": {
          "cache_duration": "none"
        },
        "template": "⚡ ",
        "foreground": "#fff",
        "type": "root",
        "style": "plain"
      }, {
        "properties": {
          "cache_duration": "none"
        },
        "template": " ⚡",
        "foreground": "#ffe603",
        "type": "text",
        "style": "plain"
      }
      ],
      "newline": true
    }
    ],
    "version": 3,
    "final_space": true
  }

   $jsonString = $data | ConvertTo-Json
      $jsonString | Out-File -FilePath $Path

}
