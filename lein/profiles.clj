{:user {:dev-dependencies [[org.clojars.gjahad/debug-repl "0.3.1"
                            org.clojure/tools.trace "0.7.6"
                            org.clojars.shicks/debug "1.1.1"]]

        :plugins [
                  [environ/environ.lein "0.3.0"]
                  [lein-deps-tree "0.1.2"]
                  [lein-droid "0.4.0-alpha4"]
                  [lein-outdated "1.0.0"]]

        :hooks [environ.leiningen.hooks]}


 :android-user {}
 :android-common {:android {:sdk-path "/Users/si/src/android-sdk-macosx"
                            :target-version 22}}
 }
