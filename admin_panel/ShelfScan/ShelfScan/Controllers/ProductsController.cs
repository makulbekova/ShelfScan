using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClosedXML.Excel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ShelfScan.Data;
using ShelfScan.Models;

namespace ShelfScan.Controllers
{
    public class ProductsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ProductsController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> DownloadCsv()
        {
            var products = await _context.ApiProducts.ToListAsync();

            var builder = new StringBuilder();
            builder.AppendLine("Name,Sku,ScanId");

            foreach (var product in products)
            {
                builder.AppendLine($"{product.Name},{product.Sku},{product.ScanId}");
            }

            byte[] csvBytes = Encoding.UTF8.GetBytes(builder.ToString());

            return File(csvBytes, "text/csv", "products.csv");
        }

        public async Task<IActionResult> DownloadExcel()
        {
            var products = await _context.ApiProducts.ToListAsync();

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Products");

                // Add headers
                worksheet.Cell(1, 1).Value = "Название";
                worksheet.Cell(1, 2).Value = "SKU";
                worksheet.Cell(1, 3).Value = "Цена обычная";
                worksheet.Cell(1, 4).Value = "Цена акционная";

                // Add data
                for (int i = 0; i < products.Count; i++)
                {
                    var product = products[i];
                    worksheet.Cell(i + 2, 1).Value = product.Name;
                    worksheet.Cell(i + 2, 2).Value = product.Sku;

                    // Retrieve regular price
                    var regularPrice = product.ApiPrices.FirstOrDefault(p => p.IsSpecialOffer);
                    if (regularPrice != null)
                    {
                        worksheet.Cell(i + 2, 3).Value = regularPrice.Price;
                    }
                    else
                    {
                        worksheet.Cell(i + 2, 3).Value = "-";
                    }

                    // Retrieve sale price
                    var salePrice = product.ApiPrices.FirstOrDefault(p => !p.IsSpecialOffer);
                    if (salePrice != null)
                    {
                        worksheet.Cell(i + 2, 4).Value = salePrice.Price;
                    }
                    else
                    {
                        worksheet.Cell(i + 2, 4).Value = "-";
                    }
                }

                // Save the Excel file to a memory stream
                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();

                    // Set content type and file name
                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "products.xlsx");
                }
            }
        }

        // GET: Products
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.ApiProducts.Include(a => a.Scan);
            return View(await applicationDbContext.ToListAsync());
        }

        // GET: Products/Details/5
        public async Task<IActionResult> Details(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiProduct = await _context.ApiProducts
                .Include(a => a.Scan)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (apiProduct == null)
            {
                return NotFound();
            }

            return View(apiProduct);
        }

        // GET: Products/Create
        public IActionResult Create()
        {
            ViewData["ScanId"] = new SelectList(_context.ApiScans, "Id", "Id");
            return View();
        }

        // POST: Products/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Name,Sku,ScanId")] ApiProduct apiProduct)
        {
            if (ModelState.IsValid)
            {
                _context.Add(apiProduct);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["ScanId"] = new SelectList(_context.ApiScans, "Id", "Id", apiProduct.ScanId);
            return View(apiProduct);
        }

        // GET: Products/Edit/5
        public async Task<IActionResult> Edit(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiProduct = await _context.ApiProducts.FindAsync(id);
            if (apiProduct == null)
            {
                return NotFound();
            }
            ViewData["ScanId"] = new SelectList(_context.ApiScans, "Id", "Id", apiProduct.ScanId);
            return View(apiProduct);
        }

        // POST: Products/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(long id, [Bind("Id,Name,Sku,ScanId")] ApiProduct apiProduct)
        {
            if (id != apiProduct.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(apiProduct);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ApiProductExists(apiProduct.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["ScanId"] = new SelectList(_context.ApiScans, "Id", "Id", apiProduct.ScanId);
            return View(apiProduct);
        }

        // GET: Products/Delete/5
        public async Task<IActionResult> Delete(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiProduct = await _context.ApiProducts
                .Include(a => a.Scan)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (apiProduct == null)
            {
                return NotFound();
            }

            return View(apiProduct);
        }

        // POST: Products/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(long id)
        {
            var apiProduct = await _context.ApiProducts.FindAsync(id);
            if (apiProduct != null)
            {
                _context.ApiProducts.Remove(apiProduct);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ApiProductExists(long id)
        {
            return _context.ApiProducts.Any(e => e.Id == id);
        }
    }
}
