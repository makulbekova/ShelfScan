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
    public class EmployeesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public EmployeesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Employees
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.ApiEmployees.Include(a => a.Role);
            return View(await applicationDbContext.ToListAsync());
        }

        // GET: Employees/Details/5
        public async Task<IActionResult> Details(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiEmployee = await _context.ApiEmployees
                .Include(a => a.Role)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (apiEmployee == null)
            {
                return NotFound();
            }

            return View(apiEmployee);
        }

        // GET: Employees/Create
        public IActionResult Create()
        {
            ViewData["RoleId"] = new SelectList(_context.ApiRoles, "Id", "Id");
            return View();
        }

        // POST: Employees/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,FirstName,LastName,Phone,HashedPassword,RoleId")] ApiEmployee apiEmployee)
        {
            if (ModelState.IsValid)
            {
                _context.Add(apiEmployee);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["RoleId"] = new SelectList(_context.ApiRoles, "Id", "Id", apiEmployee.RoleId);
            return View(apiEmployee);
        }

        // GET: Employees/Edit/5
        public async Task<IActionResult> Edit(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiEmployee = await _context.ApiEmployees.FindAsync(id);
            if (apiEmployee == null)
            {
                return NotFound();
            }
            ViewData["RoleId"] = new SelectList(_context.ApiRoles, "Id", "Id", apiEmployee.RoleId);
            return View(apiEmployee);
        }

        // POST: Employees/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(long id, [Bind("Id,FirstName,LastName,Phone,HashedPassword,RoleId")] ApiEmployee apiEmployee)
        {
            if (id != apiEmployee.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(apiEmployee);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ApiEmployeeExists(apiEmployee.Id))
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

            ViewData["RoleId"] = new SelectList(_context.ApiRoles, "Id", "Id", apiEmployee.RoleId);

            return View(apiEmployee);
        }

        // GET: Employees/Delete/5
        public async Task<IActionResult> Delete(long? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var apiEmployee = await _context.ApiEmployees
                .Include(a => a.Role)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (apiEmployee == null)
            {
                return NotFound();
            }

            return View(apiEmployee);
        }

        // POST: Employees/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(long id)
        {
            var apiEmployee = await _context.ApiEmployees.FindAsync(id);
            if (apiEmployee != null)
            {
                _context.ApiEmployees.Remove(apiEmployee);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ApiEmployeeExists(long id)
        {
            return _context.ApiEmployees.Any(e => e.Id == id);
        }
    }
}
