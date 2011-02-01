task :default => ['src/cdhit/cd-hit-est'] 

file 'src/cdhit/cd-hit-est' do
  puts 'Building CD-HIT'
  sh 'curl -LO http://www.bioinformatics.org/download.php/cd-hit/cd-hit-v4.3-2010-10-25.tgz'
  sh 'tar -zxvf cd-hit-v4.3-2010-10-25.tgz'
  cd 'cd-hit-v4.3-2010-10-25'
  sh 'make openmp=yes'
  mkdir '../src/cdhit/'
  sh 'mv cd-hit-est ../src/cdhit/'
  cd '..'
  sh 'rm -r cd-hit-v4.3-2010-10-25'
  sh 'rm cd-hit-v4.3-2010-10-25.tgz'
end
