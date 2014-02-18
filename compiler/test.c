int main()
{
	int a[2][3],b[3][2],c[2][2];
	int i,j,k;
	
	for(i=0;i<2;i++)
	{
		for(j=0;j<3;j++)
		{
			for(k=0;k<2;k++)
			{
				c[i][k] += a[i][j]*b[j][k];
			}
		}
	}
	return 0;
}