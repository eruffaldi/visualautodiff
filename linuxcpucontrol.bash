function setgov ()
{
     for i in {0..7}; 
     do 
         cpufreq-set -c $i -g $1; 
     done
}

function setfreq()
{
     for i in {0..7}; 
     do 
         cpufreq-set -c $i --min $1 --max $2; 
     done
}

