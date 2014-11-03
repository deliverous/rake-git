require 'rake/tasklib'
require 'colorize'


def git_update(repository, options = {}, &body)
    fail "repository required" if repository.nil?
    path = options[:path] || repository.pathmap("%f")
    tag = options[:tag]

    name = (Git::Groups + [path]).join(':')
    desc "Update #{repository} into #{path}"
    task "update:#{name}" do
        status = Git::update repository, path: path
        body.call(status) unless body.nil?
        if not tag.nil? then
            Dir.chdir(path) { system "git", "checkout", tag }
        else
            Dir.chdir(path) { system "git", "checkout", "master" }
        end        
    end
    desc "Status of #{path}"
    task "status:#{name}" do
        puts "== #{name}".green
        Dir.chdir(path) {system("git", "status")}
    end
    Git::TaskByGroup[-1] << name
end

def git_group(group)
    Git::Groups.push group
    Git::TaskByGroup.push []
    name = Git::Groups.join(':')
    begin
        yield if block_given?

        desc "Update group #{name}"
        task "update:#{name}"

        desc "Status for group #{name}"
        task "status:#{name}"

        Git::TaskByGroup[-1].each do |t|
            task "update:#{name}" => t
            task "status:#{name}" => t
        end
    ensure
        Git::Groups.pop
        Git::TaskByGroup.pop
    end
end


module Git
    Groups = []
    TaskByGroup = []

    def self.status path
        Dir.chdir(path) do
            system "git", "fetch"
            changes = `git status -s`
            local = `git rev-parse HEAD`
            remote = `git rev-parse @{u}`
            base = `git merge-base HEAD @{u}`

            return :local if not changes.empty?
            return :ok if local == remote
            return :pull if local == base
            return :push if remote == base
            return :merge
        end
    end

    def self.update(url, options = {})
        path = options[:path] || File.basename(url)
        name = options[:name] || path

        puts "== #{name}".green
        if Dir.exists?(path) then
            s = status path
            case s
            when :local
                puts "Local changes:"
                Dir.chdir(path) {system("git", "status", "-s")}
            when :ok
            when :pull
                Dir.chdir(path) {system("git", "pull")}
            when :push
                puts "Need to push"
            when :merge
                puts "Need to merge"
            end
            return s
        else
            system "git", "clone", url, path
            return :cloned
        end
    end    
end