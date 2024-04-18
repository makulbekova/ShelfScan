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
    public class LocationsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public LocationsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Locations
        public async Task<IActionResult> Index()
        {
            return View(await _context.ApiLocations.ToListAsync());
        }

        // GET: Locations/Details/5
        public async Task<IActionResult> Details(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiLocation = await _context.ApiLocations
                .FirstOrDefaultAsync(m => m.Id == id);
            if (apiLocation == null)
            {
                return NotFound();
            }

            return View(apiLocation);
        }

        // GET: Locations/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Locations/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Name,Address,CityId")] ApiLocation apiLocation)
        {
            if (ModelState.IsValid)
            {
                _context.Add(apiLocation);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(apiLocation);
        }

        // GET: Locations/Edit/5
        public async Task<IActionResult> Edit(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiLocation = await _context.ApiLocations.FindAsync(id);
            if (apiLocation == null)
            {
                return NotFound();
            }
            return View(apiLocation);
        }

        // POST: Locations/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(long id, [Bind("Id,Name,Address,CityId")] ApiLocation apiLocation)
        {
            if (id != apiLocation.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(apiLocation);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ApiLocationExists(apiLocation.Id))
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
            return View(apiLocation);
        }

        // GET: Locations/Delete/5
        public async Task<IActionResult> Delete(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiLocation = await _context.ApiLocations
                .FirstOrDefaultAsync(m => m.Id == id);
            if (apiLocation == null)
            {
                return NotFound();
            }

            return View(apiLocation);
        }

        // POST: Locations/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(long id)
        {
            var apiLocation = await _context.ApiLocations.FindAsync(id);
            if (apiLocation != null)
            {
                _context.ApiLocations.Remove(apiLocation);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ApiLocationExists(long id)
        {
            return _context.ApiLocations.Any(e => e.Id == id);
        }
    }
}
