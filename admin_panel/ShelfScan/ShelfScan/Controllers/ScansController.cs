using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ShelfScan.Data;
using ShelfScan.Models;

namespace ShelfScan.Controllers
{
    public class ScansController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ScansController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Scans
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.ApiScans.Include(a => a.Employee).Include(a => a.Location).Include(a => a.Photo);
            return View(await applicationDbContext.ToListAsync());
        }

        // GET: Scans/Details/5
        public async Task<IActionResult> Details(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiScan = await _context.ApiScans
                .Include(a => a.Employee)
                .Include(a => a.Location)
                .Include(a => a.Photo)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (apiScan == null)
            {
                return NotFound();
            }

            return View(apiScan);
        }

        // GET: Scans/Create
        public IActionResult Create()
        {
            ViewData["EmployeeId"] = new SelectList(_context.ApiEmployees, "Id", "Id");
            ViewData["LocationId"] = new SelectList(_context.ApiLocations, "Id", "Id");
            ViewData["PhotoId"] = new SelectList(_context.ApiPhotos, "Id", "Id");
            return View();
        }

        // POST: Scans/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,ScanDatetime,EmployeeId,LocationId,PhotoId")] ApiScan apiScan)
        {
            if (ModelState.IsValid)
            {
                _context.Add(apiScan);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["EmployeeId"] = new SelectList(_context.ApiEmployees, "Id", "Id", apiScan.EmployeeId);
            ViewData["LocationId"] = new SelectList(_context.ApiLocations, "Id", "Id", apiScan.LocationId);
            ViewData["PhotoId"] = new SelectList(_context.ApiPhotos, "Id", "Id", apiScan.PhotoId);
            return View(apiScan);
        }

        // GET: Scans/Edit/5
        public async Task<IActionResult> Edit(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiScan = await _context.ApiScans.FindAsync(id);
            if (apiScan == null)
            {
                return NotFound();
            }
            ViewData["EmployeeId"] = new SelectList(_context.ApiEmployees, "Id", "Id", apiScan.EmployeeId);
            ViewData["LocationId"] = new SelectList(_context.ApiLocations, "Id", "Id", apiScan.LocationId);
            ViewData["PhotoId"] = new SelectList(_context.ApiPhotos, "Id", "Id", apiScan.PhotoId);
            return View(apiScan);
        }

        // POST: Scans/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(long id, [Bind("Id,ScanDatetime,EmployeeId,LocationId,PhotoId")] ApiScan apiScan)
        {
            if (id != apiScan.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(apiScan);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ApiScanExists(apiScan.Id))
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
            ViewData["EmployeeId"] = new SelectList(_context.ApiEmployees, "Id", "Id", apiScan.EmployeeId);
            ViewData["LocationId"] = new SelectList(_context.ApiLocations, "Id", "Id", apiScan.LocationId);
            ViewData["PhotoId"] = new SelectList(_context.ApiPhotos, "Id", "Id", apiScan.PhotoId);
            return View(apiScan);
        }

        // GET: Scans/Delete/5
        public async Task<IActionResult> Delete(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiScan = await _context.ApiScans
                .Include(a => a.Employee)
                .Include(a => a.Location)
                .Include(a => a.Photo)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (apiScan == null)
            {
                return NotFound();
            }

            return View(apiScan);
        }

        // POST: Scans/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(long id)
        {
            var apiScan = await _context.ApiScans.FindAsync(id);
            if (apiScan != null)
            {
                _context.ApiScans.Remove(apiScan);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ApiScanExists(long id)
        {
            return _context.ApiScans.Any(e => e.Id == id);
        }
    }
}
