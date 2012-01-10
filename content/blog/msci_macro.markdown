---
created_at: 2010-02-23
foo: bar_
excerpt: One of the assignments for MSCI 261 requires spreadsheets.
kind: article
tags: [ msci, msci261, openoffice, excel, spreadsheet ]
title: MSCI261 macro for OpenOffice Calc and Microsoft Excel
---

One of the assignments for MSCI 261 (engineering economics) requires spreadsheets.  However, the financial formulae in Excel and [OpenOffice.org][ooo] are slightly different from the formulae we use in the course.  This was slightly annoying, so I decided to define some of my own functions for OpenOffice.

(This post assumes basic knowledge of Excel/OpenOffice functions, and MSCI261.)

[ooo]: http://www.openoffice.org/

Here is the code:

    REM  *****  BASIC  *****
    Option Explicit

    Sub Main

    End Sub

    Function FP(P, i, N)
      REM Compound Amount (F/P) Factor

      FP = P * (1 + i)^N
    End Function

    Function PF(F, i, N)
      REM Present Worth (P/F) Factor

      PF = F / (1 + i)^N
    End Function

    Function AF(F, i, N)
      REM Sinking Fund (A/F) Factor

      AF = (F * i) / ((1 + i)^N - 1)
    End Function

    Function FA(A, i, N)
      REM Uniform Series Compound Amount (F/A) Factor

      FA = A * (((1 + i)^N - 1) / i)
    End Function

    Function AP(P, i, N)
      REM Capital Recovery (A/P) Factor

      AP = (P * i * (1 + i)^N) / ((1 + i)^N - 1)
    End Function

    Function PA(A, i, N)
      REM Series Present Worth (P/A) Factor

      PA = A * (((1 + i)^N - 1) / (i * (1 + i)^N))
    End Function

    Function AG(A, G, i, N)
      REM Arithmetic Gradient to Annuity Conversion (A/G) Factor
      REM Returns A_tot

      AG = A + G*((1 / i) - (N / ((1 + i)^N - 1)))
    End Function

    Function PAg(A, g, i, N)
      REM Geometric Gradient Series to Present Worth Conversion Factor

      Dim i_o As Double
      i_o = ((1 + i) / (1 + g)) - 1

      PAg = A * ((((1 + i_o)^N - 1) / (i_o * (1 + i_o)^N)) / (1 + g))
    End Function

This is how to get these functions working in OpenOffice:

 1. Copy the above code.
 2. Go to Tools > Macros > Organize Macros > OpenOffice.org Basic
 3. In the "Macro from" field, select the name of your document and click New.
 4. You can leave the module name as "Module1" or call it something like "MsciFunctions." Click OK.
 5. In the BASIC-IDE window that comes up, delete everything and paste the above code.
 6. Close it, and you're done!

All of the functions except the Arithmetic and Geometric Gradients have only three arguments.  The first is the amount of money you're multiplying the factor by (eg for the A/P factor, the first argument is P), the second is the interest rate (as a decimal, so 10% would be entered as 0.1), and the third is the number of periods.

The Arithmetic Gradient factor looks like this: (A, G, i, N)
Where A is the original amount, G is the (constant) amount it grows, i is the interest rate, and N is the number of periods.  The function returns a single, constant annuity.

Similarly, the Geometric Gradient looks like this: (A, g, i, N)
g is the percent A grows by each period.  This function returns the present worth of the entire geometric gradient series.

Anyway, this quickly-written post should be enough to get you going on the assignment.  If not, just leave a comment or send me an email.  Also, I'd like to hear from anyone who attempts this with Excel and gets it working.

Updates
-------
<div class="date">February 25, 2010</div>

If you're a bit lazier and don't mind enabling macros in OpenOffice, you can download [this spreadsheet][oo-spreadsheet].  Under default settings, when you open it, it should say something about macros being disabled.  To enable them, go to Tools > Options > Security > Macro security and select Medium.  Then close the file and reopen it.  This time it'll ask if you want to enable or disable macros.  If you trust me, then you can click Enable.  (If not, then just follow the above instructions to manually insert the macro.)

Chris Kleynhans has provided a Microsoft Excel version of the [spreadsheet][excel-spreadsheet].  Once again, you'll have to enable the macro -- there should be a little bar that appears, where you can click on Options. 

[oo-spreadsheet]: http://files.mhyee.com/msci_macros.ods
[excel-spreadsheet]: http://files.mhyee.com/msci_macros_excel.xlsm
