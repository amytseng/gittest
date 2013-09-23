#include <iterator>
#include<iostream>
#include<fstream>
#include<string>
#include<vector>
#include <algorithm>
#include <cstring>
#include <sstream>
#include <boost/algorithm/string.hpp>
#include <boost/lexical_cast.hpp>


class Repseq 
{
	public:
		std::string seq;
		double org_weight;
		double reads;
		double weight;
		Repseq ();
		std::vector<std::string> data;

		void set_vaule ( std::string , double ,double );
		void print_Repseq (Repseq );
};

Repseq::Repseq()
{
	seq = "DEFAULT";
	org_weight = 0;
	reads = 1;
	weight = 0.0;
}


void Repseq:: set_vaule (std::string set_seq, double set_org_weight, double set_reads)
{

	seq = set_seq;
	reads = set_reads;
	org_weight = set_org_weight;

}

void Repseq::print_Repseq(Repseq rp)
{
	std::vector<std::string>:: iterator iter = rp.data.begin();



	for( int ix = 0; iter != rp.data.end(); ++iter, ++ix)
	{ 
		std::cout << rp.seq << "\t" << rp.weight << "\t"  ;
		std::cout << *iter << std::endl;

	}  

}


void computeweight (double org_weight,  double reads, double &weight)

{
	weight = org_weight/reads;
}

void addreads(double &reads)
{ 
	reads = reads + 1; 
	//	return reads; 
} 



int main ()
{
	std::vector <int>::size_type ii; 
	char str[1000];//to string
	std:: fstream fin ;
	fin.open("/nfs92/nfs_sharing/amy/finish_miR/wt_454_prefix.prefix_nomatch",std::ios::in);
	bool first = true;
	Repseq rp; 
	std::string tmp("");
	std::string tmp_orgw;
	char *delim = "\t";
	char *nextline = "\n";
	while (fin.getline(str,sizeof(str)) )

	{
		if (first)
		{

			rp.seq = std::strtok(str, delim);//cut1
			tmp = rp.seq;
			tmp_orgw = std::strtok(NULL, delim);//cut2
			rp.org_weight = atof(tmp_orgw.c_str());
			rp.data.push_back(std::strtok(NULL, nextline)); //cut3
			first = false;
		}
		else if (!first)
		{
			std::string tempseq = std::strtok(str, delim);//cut1

			if( tempseq == tmp )
			{	
				std::strtok(NULL, delim);//cut2
				rp.data.push_back(std::strtok(NULL, nextline)); //cut3
				addreads(rp.reads);
			}
			else 
			{
				computeweight(rp.org_weight , rp.reads , rp.weight);
				rp.print_Repseq(rp);
				rp.set_vaule ("DEFAULT",0.0,1.0);
				rp.data.clear();
				rp.seq = tempseq;
				std::strtok(NULL, delim);//cut2
				rp.org_weight = atof(tmp_orgw.c_str());
				rp.data.push_back(std::strtok(NULL, nextline)); //cut3	
				tmp = rp.seq;

			}
		}

	}

	rp.print_Repseq(rp);

	return 0;

}
