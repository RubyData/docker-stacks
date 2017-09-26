OWNER = 'rubydata'.freeze
ALL_IMAGES = %w[
  base
  notebooks
].each(&:freeze).freeze

DOCKER_FLAGS = ENV['DOCKER_FLAGS']

ALL_IMAGES.each do |image|
  desc "Build #{OWNER}/#{image} image"
  task "build/#{image}" do
    sh "docker build #{DOCKER_FLAGS} --rm --force-rm -t #{OWNER}/#{image}:latest ./#{image}"
  end

  desc "Push #{OWNER}/#{image} image"
  task "push/#{image}" do
    sh "docker push #{OWNER}/#{image}:latest"
  end
end


desc "Build all images"
task "build-all" do
  ALL_IMAGES.each do |image|
    Rake::Task["build/#{image}"].invoke
  end
end


desc "Push all images"
task "push-all" do
  ALL_IMAGES.each do |image|
    Rake::Task["push/#{image}"].invoke
  end
end
