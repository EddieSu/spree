# 建議先用 Ruby 3.2，避免你 log 裡 RubyGems 更新踩到 Ruby 3.1.4 的版本門檻
FROM ruby:3.2-slim

WORKDIR /app

# 基礎編譯工具（先最小化，後續若遇到缺 lib 再加）
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git && \
    rm -rf /var/lib/apt/lists/*

# 不要跑 gem update --system（你 log 顯示會拉到 rubygems-update 4.x 需要 Ruby >=3.2）
RUN gem install -N bundler

# 關鍵：Gemfile 會引用 common_spree_dependencies.rb，而且也會用到 gemspec
COPY Gemfile Gemfile.lock* ./
COPY common_spree_dependencies.rb ./
COPY spree.gemspec ./

RUN bundle install

# 先放一個預設命令，至少讓 image build 過；後續再依你的實際啟動方式調整
CMD ["bash", "-lc", "ruby -v && bundle -v && echo 'Image built successfully' && sleep 3600"]
