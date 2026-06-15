class Termeric < Formula
  desc "Golden prompts for your terminal"
  homepage "https://modib.github.io/termeric/"
  url "https://github.com/modib/termeric/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c4a1848943f5f3a018e43c5853f1fcec4cf9b6f30ed3c08309e0bb3cc6cd1972"
  license "MIT"
  head "https://github.com/modib/termeric.git", branch: "main"

  depends_on "bash"
  depends_on "zsh"
  depends_on "jq"
  depends_on "curl"
  depends_on "fish" => :recommended

  def install
    pkgshare.install "termeric_bash", "termeric_zsh", "termeric_fish"
    pkgshare.install "ai"
    bin.install "bin/termeric"
    bash_completion.install "completions/termeric.bash" => "termeric"
    zsh_completion.install "completions/termeric.zsh" => "_termeric"
    fish_completion.install "completions/termeric.fish" => "termeric.fish"
  end

  def caveats
    <<~EOS
      To activate termeric, run:

        termeric install

      Or manually add to your shell config:

        bash (~/.bashrc):
          if [ -f #{pkgshare}/termeric_bash ]; then
              . #{pkgshare}/termeric_bash
          fi

        zsh (~/.zshrc):
          if [ -f #{pkgshare}/termeric_zsh ]; then
              . #{pkgshare}/termeric_zsh
          fi

        fish (~/.config/fish/config.fish):
          source #{pkgshare}/termeric_fish

      For powerline mode (recommended):

        termeric font

      AI agent (new in 1.6.0):

        termeric ai doctor   # check system readiness
        termeric ai config   # create config template
        termeric ai agent    # start interactive session

      Configuration (set before sourcing):

        PROMPT_COLOR=on        Master color switch: on (default) or off
        PROMPT_SHOW_USER=on    Show user@host segment (default: on)
        PROMPT_SHOW_EXIT=on    Show exit code on failure (default: on)
        PROMPT_SHOW_DIR=on     Show directory path (default: on)
        PROMPT_SHOW_SSH=on     Show SSH indicator when connected (default: on)
        PROMPT_SHOW_TIME=off   Show command duration when >=2s (default: off)
        PROMPT_STYLE=0         Prompt style: 0=powerline, 1=basename, 2=abbreviated, 3=full path, 4=long text (default: 0)
        PROMPT_VENV=off        Show Python virtualenv/conda name (default: off)
        PROMPT_NODE=off        Show Node.js version (default: off)
        PROMPT_K8S=off         Show Kubernetes context (default: off)
        AI_BACKEND=groq        Default AI backend: groq, ollama, openai
        AI_MODEL=              Override default model per backend
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termeric version")
    assert_match "ai", shell_output("#{bin}/termeric help")
  end
end
